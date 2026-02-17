import { Astal, Gtk } from 'ags/gtk3';
import { execAsync } from 'ags/process';
import { idle } from 'ags/time';

import { hyprMessage } from '../../lib';
import { getCssProvider, setCss, toggleClassName } from '../../lib/widgets';
import Tablet from '../../services/tablet';
import { Keys } from './keys';
import OskWindow from './osk-window';

const KEY_N = 249;
const KEYCODES = Array.from(Array(KEY_N).keys()).map(
    (keycode) => `${keycode}:0`,
);

const ANIM_DURATION = 700;

const releaseAllKeys = () => {
    execAsync(['ydotool', 'key', ...KEYCODES]).catch(print);
};

// FIXME: hard to start with fingers
export default (win: OskWindow) => {
    const tablet = Tablet.get_default();

    let signals = [] as number[];
    let calculatedHeight = 0;

    idle(() => {
        calculatedHeight = win.get_allocated_height();
        tablet.oskState = false;

        setTimeout(() => {
            toggleClassName(win.get_grandchildren()[0], 'hidden', false);
            win.set_exclusivity(Astal.Exclusivity.EXCLUSIVE);
        }, ANIM_DURATION * 3);
    });

    const provider = getCssProvider(win.get_child());

    const gesture = Gtk.GestureDrag.new(win);

    tablet.connect('notify::osk-state', () => {
        if (tablet.oskState) {
            win.setSlideDown();

            setCss(
                provider,
                `
                    transition: margin-bottom ${ANIM_DURATION}ms cubic-bezier(0.36, 0, 0.66, -0.56);
                    margin-bottom: 0px;
                `,
            );
        }
        else {
            releaseAllKeys();

            win.setSlideUp();

            setCss(
                provider,
                `
                    transition: margin-bottom ${ANIM_DURATION}ms cubic-bezier(0.36, 0, 0.66, -0.56);
                    margin-bottom: -${calculatedHeight}px;
                `,
            );
        }
    });

    win.killGestureSigs = () => {
        signals.forEach((id) => {
            gesture.disconnect(id);
        });
        signals = [];
        win.startY = null;
    };

    win.setSlideUp = () => {
        win.killGestureSigs();

        // Begin drag
        signals.push(
            gesture.connect('drag-begin', () => {
                hyprMessage('j/cursorpos').then((out) => {
                    win.startY = JSON.parse(out).y;
                });
            }),
        );

        // Update drag
        signals.push(
            gesture.connect('drag-update', () => {
                hyprMessage('j/cursorpos').then((out) => {
                    if (!win.startY) {
                        return;
                    }

                    const currentY = JSON.parse(out).y;
                    const offset = win.startY - currentY;

                    if (offset < 0) {
                        setCss(
                            provider,
                            `
                                transition: margin-bottom 0.5s ease-in-out;
                                margin-bottom: -${calculatedHeight}px;
                            `,
                        );

                        return;
                    }

                    if (offset > calculatedHeight) {
                        setCss(
                            provider,
                            `
                                margin-bottom: 0px;
                            `,
                        );
                    }
                    else {
                        setCss(
                            provider,
                            `
                                margin-bottom: ${offset - calculatedHeight}px;
                            `,
                        );
                    }
                });
            }),
        );

        // End drag
        signals.push(
            gesture.connect('drag-end', () => {
                hyprMessage('j/cursorpos').then((out) => {
                    if (!win.startY) {
                        return;
                    }

                    const currentY = JSON.parse(out).y;
                    const offset = win.startY - currentY;

                    if (offset > calculatedHeight) {
                        setCss(
                            provider,
                            `
                                transition: margin-bottom 0.5s ease-in-out;
                                margin-bottom: 0px;
                            `,
                        );
                        tablet.oskState = true;
                    }
                    else {
                        setCss(
                            provider,
                            `
                                transition: margin-bottom 0.5s ease-in-out;
                                margin-bottom: -${calculatedHeight}px;
                            `,
                        );
                    }

                    win.startY = null;
                });
            }),
        );
    };

    win.setSlideDown = () => {
        win.killGestureSigs();

        // Begin drag
        signals.push(
            gesture.connect('drag-begin', () => {
                hyprMessage('j/cursorpos').then((out) => {
                    const hasActiveKey = Keys()
                        .map((v) => v())
                        .includes(true);

                    if (!hasActiveKey) {
                        win.startY = JSON.parse(out).y;
                    }
                });
            }),
        );

        // Update drag
        signals.push(
            gesture.connect('drag-update', () => {
                hyprMessage('j/cursorpos').then((out) => {
                    if (!win.startY) {
                        return;
                    }

                    const currentY = JSON.parse(out).y;
                    const offset = win.startY - currentY;

                    if (offset > 0) {
                        setCss(
                            provider,
                            `
                                transition: margin-bottom 0.5s ease-in-out;
                                margin-bottom: 0px;
                            `,
                        );

                        return;
                    }

                    setCss(
                        provider,
                        `
                            margin-bottom: ${offset}px;
                        `,
                    );
                });
            }),
        );

        // End drag
        signals.push(
            gesture.connect('drag-end', () => {
                hyprMessage('j/cursorpos').then((out) => {
                    if (!win.startY) {
                        return;
                    }

                    const currentY = JSON.parse(out).y;
                    const offset = win.startY - currentY;

                    if (offset < -((calculatedHeight * 2) / 3)) {
                        setCss(
                            provider,
                            `
                                transition: margin-bottom 0.5s ease-in-out;
                                margin-bottom: -${calculatedHeight}px;
                            `,
                        );

                        tablet.oskState = false;
                    }
                    else {
                        setCss(
                            provider,
                            `
                                transition: margin-bottom 0.5s ease-in-out;
                                margin-bottom: 0px;
                            `,
                        );
                    }

                    win.startY = null;
                });
            }),
        );
    };

    return win;
};

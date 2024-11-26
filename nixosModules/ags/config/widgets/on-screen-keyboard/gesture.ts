import { execAsync, idle } from 'astal';
import { Astal, Gtk } from 'astal/gtk3';

import Tablet from '../../services/tablet';
import { hyprMessage } from '../../lib';

import OskWindow from './osk-window';


const KEY_N = 249;
const KEYCODES = Array.from(Array(KEY_N).keys());

const ANIM_DURATION = 700;

const releaseAllKeys = () => {
    execAsync([
        'ydotool', 'key',
        ...KEYCODES.map((keycode) => `${keycode}:0`),
    ]).catch(print);
};

export default (window: OskWindow) => {
    const tablet = Tablet.get_default();

    let signals = [] as number[];
    let calculatedHeight = 0;

    idle(() => {
        calculatedHeight = window.get_allocated_height();
        tablet.oskState = false;

        setTimeout(() => {
            window.get_grandchildren()[0].toggleClassName('hidden', false);
            window.set_exclusivity(Astal.Exclusivity.EXCLUSIVE);
        }, ANIM_DURATION * 3);
    });

    const gesture = Gtk.GestureDrag.new(window);

    window.hook(tablet, 'notify::osk-state', () => {
        if (tablet.oskState) {
            window.setSlideDown();

            window.get_child().css = `
                transition: margin-bottom ${ANIM_DURATION}ms cubic-bezier(0.36, 0, 0.66, -0.56);
                margin-bottom: 0px;
            `;
        }
        else {
            releaseAllKeys();

            window.setSlideUp();

            window.get_child().css = `
                transition: margin-bottom ${ANIM_DURATION}ms cubic-bezier(0.36, 0, 0.66, -0.56);
                margin-bottom: -${calculatedHeight}px;
            `;
        }
    });

    window.killGestureSigs = () => {
        signals.forEach((id) => {
            gesture.disconnect(id);
        });
        signals = [];
        window.startY = null;
    };

    window.setSlideUp = () => {
        window.killGestureSigs();

        // Begin drag
        signals.push(
            gesture.connect('drag-begin', () => {
                hyprMessage('j/cursorpos').then((out) => {
                    window.startY = JSON.parse(out).y;
                });
            }),
        );

        // Update drag
        signals.push(
            gesture.connect('drag-update', () => {
                hyprMessage('j/cursorpos').then((out) => {
                    if (!window.startY) {
                        return;
                    }

                    const currentY = JSON.parse(out).y;
                    const offset = window.startY - currentY;

                    if (offset < 0) {
                        window.get_child().css = `
                            transition: margin-bottom 0.5s ease-in-out;
                            margin-bottom: -${calculatedHeight}px;
                        `;

                        return;
                    }

                    if (offset > calculatedHeight) {
                        window.get_child().css = `
                            margin-bottom: 0px;
                        `;
                    }
                    else {
                        window.get_child().css = `
                            margin-bottom: ${offset - calculatedHeight}px;
                        `;
                    }
                });
            }),
        );

        // End drag
        signals.push(
            gesture.connect('drag-end', () => {
                hyprMessage('j/cursorpos').then((out) => {
                    if (!window.startY) {
                        return;
                    }

                    const currentY = JSON.parse(out).y;
                    const offset = window.startY - currentY;

                    if (offset > calculatedHeight) {
                        window.get_child().css = `
                            transition: margin-bottom 0.5s ease-in-out;
                            margin-bottom: 0px;
                        `;
                        tablet.oskState = true;
                    }
                    else {
                        window.get_child().css = `
                            transition: margin-bottom 0.5s ease-in-out;
                            margin-bottom: -${calculatedHeight}px;
                        `;
                    }
                });
            }),
        );
    };

    window.setSlideDown = () => {
        window.killGestureSigs();

        // Begin drag
        signals.push(
            gesture.connect('drag-begin', () => {
                hyprMessage('j/cursorpos').then((out) => {
                    window.startY = JSON.parse(out).y;
                });
            }),
        );

        // Update drag
        signals.push(
            gesture.connect('drag-update', () => {
                hyprMessage('j/cursorpos').then((out) => {
                    if (!window.startY) {
                        return;
                    }

                    const currentY = JSON.parse(out).y;
                    const offset = window.startY - currentY;

                    if (offset > 0) {
                        window.get_child().css = `
                            transition: margin-bottom 0.5s ease-in-out;
                            margin-bottom: 0px;
                        `;

                        return;
                    }

                    window.get_child().css = `
                        margin-bottom: ${offset}px;
                    `;
                });
            }),
        );

        // End drag
        signals.push(
            gesture.connect('drag-end', () => {
                hyprMessage('j/cursorpos').then((out) => {
                    if (!window.startY) {
                        return;
                    }

                    const currentY = JSON.parse(out).y;
                    const offset = window.startY - currentY;

                    if (offset < -(calculatedHeight * 2 / 3)) {
                        window.get_child().css = `
                            transition: margin-bottom 0.5s ease-in-out;
                            margin-bottom: -${calculatedHeight}px;
                        `;

                        tablet.oskState = false;
                    }
                    else {
                        window.get_child().css = `
                            transition: margin-bottom 0.5s ease-in-out;
                            margin-bottom: 0px;
                        `;
                    }
                });
            }),
        );
    };

    return window;
};

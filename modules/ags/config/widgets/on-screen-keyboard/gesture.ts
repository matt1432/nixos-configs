import { Astal, Gdk, Gtk } from 'ags/gtk4';
import { execAsync } from 'ags/process';

import { hyprMessage } from '../../lib';
import { toggleClassName } from '../../lib/widgets';
import Tablet from '../../services/tablet';
import { Keys } from './keys';
import OskWindow from './osk-window';
import { easeInBack, easeInOut, Slider } from './slide';

const KEY_N = 249;
const KEYCODES = Array.from(Array(KEY_N).keys()).map(
    (keycode) => `${keycode}:0`,
);

const ANIM_DURATION = 700;
const SNAP_DURATION = 500;

const releaseAllKeys = () => {
    execAsync(['ydotool', 'key', ...KEYCODES]).catch(print);
};

export default (win: OskWindow) => {
    const tablet = Tablet.get_default();
    const slider = new Slider(win);

    let signals = [] as number[];
    let calculatedHeight = 0;
    let isTouch = false;

    // Wait for the window to be allocated to know its height
    win.add_tick_callback(() => {
        if (win.get_height() === 0) {
            return true;
        }

        calculatedHeight = win.get_height();
        tablet.oskState = false;

        setTimeout(() => {
            toggleClassName(win.get_grandchildren()[0], 'hidden', false);
            win.set_exclusivity(Astal.Exclusivity.EXCLUSIVE);
        }, ANIM_DURATION * 3);

        return false;
    });

    const gesture = new Gtk.GestureDrag();

    win.add_controller(gesture);

    tablet.connect('notify::osk-state', () => {
        if (tablet.oskState) {
            win.setSlideDown();
            slider.animate(0, ANIM_DURATION, easeInBack);
        }
        else {
            releaseAllKeys();

            win.setSlideUp();
            slider.animate(-calculatedHeight, ANIM_DURATION, easeInBack);
        }
    });

    win.killGestureSigs = () => {
        signals.forEach((id) => {
            gesture.disconnect(id);
        });
        signals = [];
        win.startY = null;
    };

    const isTouchEvent = () =>
        gesture.get_current_event_device()?.get_source() ===
        Gdk.InputSource.TOUCHSCREEN;

    win.setSlideUp = () => {
        win.killGestureSigs();

        // Begin drag
        signals.push(
            gesture.connect('drag-begin', () => {
                isTouch = isTouchEvent();

                hyprMessage('j/cursorpos').then((out) => {
                    win.startY = JSON.parse(out).y;
                });
            }),
        );

        let lastOffset = 0;

        // Update drag
        signals.push(
            gesture.connect('drag-update', () => {
                hyprMessage(isTouch ? 'j/touchpos' : 'j/cursorpos')
                    .then((out) => {
                        if (!win.startY) {
                            return;
                        }

                        const currentY = isTouch
                            ? JSON.parse(out)['0'].y
                            : JSON.parse(out).y;

                        const offset = (lastOffset = win.startY - currentY);

                        if (offset < 0) {
                            slider.animate(
                                -calculatedHeight,
                                SNAP_DURATION,
                                easeInOut,
                            );

                            return;
                        }

                        if (offset > calculatedHeight) {
                            slider.set(0);
                        }
                        else {
                            slider.set(offset - calculatedHeight);
                        }
                    })
                    .catch(console.error);
            }),
        );

        // End drag
        signals.push(
            gesture.connect('drag-end', () => {
                if (!win.startY) {
                    return;
                }

                if (lastOffset > calculatedHeight) {
                    slider.animate(0, SNAP_DURATION, easeInOut);
                    tablet.oskState = true;
                }
                else {
                    slider.animate(-calculatedHeight, SNAP_DURATION, easeInOut);
                }

                win.startY = null;
            }),
        );
    };

    win.setSlideDown = () => {
        win.killGestureSigs();

        // Begin drag
        signals.push(
            gesture.connect('drag-begin', () => {
                isTouch = isTouchEvent();

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

        let lastOffset = 0;

        // Update drag
        signals.push(
            gesture.connect('drag-update', () => {
                hyprMessage(isTouch ? 'j/touchpos' : 'j/cursorpos')
                    .then((out) => {
                        if (!win.startY) {
                            return;
                        }

                        const currentY = isTouch
                            ? JSON.parse(out)['0'].y
                            : JSON.parse(out).y;
                        const offset = (lastOffset = win.startY - currentY);

                        if (offset > 0) {
                            slider.animate(0, SNAP_DURATION, easeInOut);

                            return;
                        }

                        slider.set(offset);
                    })
                    .catch(console.error);
            }),
        );

        // End drag
        signals.push(
            gesture.connect('drag-end', () => {
                if (!win.startY) {
                    return;
                }

                if (lastOffset < -((calculatedHeight * 2) / 3)) {
                    slider.animate(-calculatedHeight, SNAP_DURATION, easeInOut);

                    tablet.oskState = false;
                }
                else {
                    slider.animate(0, SNAP_DURATION, easeInOut);
                }

                win.startY = null;
            }),
        );
    };

    return win;
};

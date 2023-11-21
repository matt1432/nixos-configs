import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

import { execAsync, timeout } from 'resource:///com/github/Aylur/ags/utils.js';

import Gtk from 'gi://Gtk';

import Tablet from '../../services/tablet.js';

const KEY_N = 249;
const HIDDEN_MARGIN = 340;
const ANIM_DURATION = 700;


const releaseAllKeys = () => {
    const keycodes = Array.from(Array(KEY_N).keys());

    execAsync([
        'ydotool', 'key',
        ...keycodes.map((keycode) => `${keycode}:0`),
    ]).catch(print);
};

export default (window) => {
    window.child.setCss(`margin-bottom: -${HIDDEN_MARGIN}px;`);
    const gesture = Gtk.GestureDrag.new(window);

    window.setVisible = (state) => {
        if (state) {
            window.visible = true;
            window.setSlideDown();
            window.child.setCss(`
                transition: margin-bottom 0.7s
                    cubic-bezier(0.36, 0, 0.66, -0.56);
                margin-bottom: 0px;
            `);
        }
        else {
            timeout(ANIM_DURATION + 10, () => {
                if (!Tablet.tabletMode) {
                    window.visible = false;
                }
            });
            releaseAllKeys();
            window.setSlideUp();
            window.child.setCss(`
                transition: margin-bottom 0.7s
                    cubic-bezier(0.36, 0, 0.66, -0.56);
                margin-bottom: -${HIDDEN_MARGIN}px;
            `);
        }
    };

    gesture.signals = [];
    window.killGestureSigs = () => {
        gesture.signals.forEach((id) => {
            gesture.disconnect(id);
        });
        gesture.signals = [];
    };

    window.setSlideUp = () => {
        window.killGestureSigs();

        // Begin drag
        gesture.signals.push(
            gesture.connect('drag-begin', () => {
                Hyprland.sendMessage('j/cursorpos').then((out) => {
                    gesture.startY = JSON.parse(out).y;
                });
            }),
        );

        // Update drag
        gesture.signals.push(
            gesture.connect('drag-update', () => {
                Hyprland.sendMessage('j/cursorpos').then((out) => {
                    const currentY = JSON.parse(out).y;
                    const offset = gesture.startY - currentY;

                    if (offset < 0) {
                        return;
                    }

                    window.child.setCss(`
                        margin-bottom: ${offset - HIDDEN_MARGIN}px;
                    `);
                });
            }),
        );

        // End drag
        gesture.signals.push(
            gesture.connect('drag-end', () => {
                window.child.setCss(`
                    transition: margin-bottom 0.5s ease-in-out;
                    margin-bottom: -${HIDDEN_MARGIN}px;
                `);
            }),
        );
    };

    window.setSlideDown = () => {
        window.killGestureSigs();

        // Begin drag
        gesture.signals.push(
            gesture.connect('drag-begin', () => {
                Hyprland.sendMessage('j/cursorpos').then((out) => {
                    gesture.startY = JSON.parse(out).y;
                });
            }),
        );

        // Update drag
        gesture.signals.push(
            gesture.connect('drag-update', () => {
                Hyprland.sendMessage('j/cursorpos').then((out) => {
                    const currentY = JSON.parse(out).y;
                    const offset = gesture.startY - currentY;

                    if (offset > 0) {
                        return;
                    }

                    window.child.setCss(`
                        margin-bottom: ${offset}px;
                    `);
                });
            }),
        );

        // End drag
        gesture.signals.push(
            gesture.connect('drag-end', () => {
                window.child.setCss(`
                    transition: margin-bottom 0.5s ease-in-out;
                    margin-bottom: 0px;
                `);
            }),
        );
    };

    return window;
};

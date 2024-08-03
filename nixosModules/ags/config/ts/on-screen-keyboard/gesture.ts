const Hyprland = await Service.import('hyprland');

const { execAsync, timeout } = Utils;

const { Gtk } = imports.gi;

import Tablet from '../../services/tablet.ts';

const KEY_N = 249;
const HIDDEN_MARGIN = 340;
const ANIM_DURATION = 700;

// Types
import { OskWindow } from 'global-types';


const releaseAllKeys = () => {
    const keycodes = Array.from(Array(KEY_N).keys());

    execAsync([
        'ydotool', 'key',
        ...keycodes.map((keycode) => `${keycode}:0`),
    ]).catch(print);
};

export default (window: OskWindow) => {
    const gesture = Gtk.GestureDrag.new(window);

    window.child.setCss(`margin-bottom: -${HIDDEN_MARGIN}px;`);

    let signals = [] as number[];

    window.attribute = {
        startY: null,

        setVisible: (state: boolean) => {
            if (state) {
                window.visible = true;
                window.attribute.setSlideDown();

                window.child.setCss(`
                    transition: margin-bottom 0.7s
                        cubic-bezier(0.36, 0, 0.66, -0.56);
                    margin-bottom: 0px;
                `);
            }
            else {
                timeout(ANIM_DURATION + 100 + 100, () => {
                    if (!Tablet.tabletMode) {
                        window.visible = false;
                    }
                });
                releaseAllKeys();
                window.attribute.setSlideUp();

                window.child.setCss(`
                    transition: margin-bottom 0.7s
                        cubic-bezier(0.36, 0, 0.66, -0.56);
                    margin-bottom: -${HIDDEN_MARGIN}px;
                `);
            }
        },

        killGestureSigs: () => {
            signals.forEach((id) => {
                gesture.disconnect(id);
            });
            signals = [];
            window.attribute.startY = null;
        },

        setSlideUp: () => {
            window.attribute.killGestureSigs();

            // Begin drag
            signals.push(
                gesture.connect('drag-begin', () => {
                    Hyprland.messageAsync('j/cursorpos').then((out) => {
                        window.attribute.startY = JSON.parse(out).y;
                    });
                }),
            );

            // Update drag
            signals.push(
                gesture.connect('drag-update', () => {
                    Hyprland.messageAsync('j/cursorpos').then((out) => {
                        if (!window.attribute.startY) {
                            return;
                        }

                        const currentY = JSON.parse(out).y;
                        const offset = window.attribute.startY - currentY;

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
            signals.push(
                gesture.connect('drag-end', () => {
                    window.child.setCss(`
                        transition: margin-bottom 0.5s ease-in-out;
                        margin-bottom: -${HIDDEN_MARGIN}px;
                    `);
                }),
            );
        },

        setSlideDown: () => {
            window.attribute.killGestureSigs();

            // Begin drag
            signals.push(
                gesture.connect('drag-begin', () => {
                    Hyprland.messageAsync('j/cursorpos').then((out) => {
                        window.attribute.startY = JSON.parse(out).y;
                    });
                }),
            );

            // Update drag
            signals.push(
                gesture.connect('drag-update', () => {
                    Hyprland.messageAsync('j/cursorpos').then((out) => {
                        if (!window.attribute.startY) {
                            return;
                        }

                        const currentY = JSON.parse(out).y;
                        const offset = window.attribute.startY - currentY;

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
            signals.push(
                gesture.connect('drag-end', () => {
                    window.child.setCss(`
                        transition: margin-bottom 0.5s ease-in-out;
                        margin-bottom: 0px;
                    `);
                }),
            );
        },
    };

    return window;
};

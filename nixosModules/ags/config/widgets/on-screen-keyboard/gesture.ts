import { execAsync } from 'astal';
import { Gtk } from 'astal/gtk3';

import { hyprMessage } from '../../lib';

import OskWindow from './osk-window';


const KEY_N = 249;
const HIDDEN_MARGIN = 340;

const releaseAllKeys = () => {
    const keycodes = Array.from(Array(KEY_N).keys());

    execAsync([
        'ydotool', 'key',
        ...keycodes.map((keycode) => `${keycode}:0`),
    ]).catch(print);
};

export default (window: OskWindow) => {
    const gesture = Gtk.GestureDrag.new(window);

    window.get_child().css = `margin-bottom: -${HIDDEN_MARGIN}px;`;

    let signals = [] as number[];

    window.setVisible = (state: boolean) => {
        if (state) {
            window.setSlideDown();

            window.get_child().css = `
                transition: margin-bottom 0.7s cubic-bezier(0.36, 0, 0.66, -0.56);
                margin-bottom: 0px;
            `;
        }
        else {
            releaseAllKeys();
            window.setSlideUp();

            window.get_child().css = `
                transition: margin-bottom 0.7s cubic-bezier(0.36, 0, 0.66, -0.56);
                margin-bottom: -${HIDDEN_MARGIN}px;
            `;
        }
    };

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
                            margin-bottom: -${HIDDEN_MARGIN}px;
                        `;

                        return;
                    }

                    window.get_child().css = `
                        margin-bottom: ${offset - HIDDEN_MARGIN}px;
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

                    if (offset > HIDDEN_MARGIN) {
                        window.get_child().css = `
                            transition: margin-bottom 0.5s ease-in-out;
                            margin-bottom: 0px;
                        `;
                        window.setVisible(true);
                    }
                    else {
                        window.get_child().css = `
                            transition: margin-bottom 0.5s ease-in-out;
                            margin-bottom: -${HIDDEN_MARGIN}px;
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

                    if (offset < -(HIDDEN_MARGIN * 2 / 3)) {
                        window.get_child().css = `
                            transition: margin-bottom 0.5s ease-in-out;
                            margin-bottom: -${HIDDEN_MARGIN}px;
                        `;

                        window.setVisible(false);
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

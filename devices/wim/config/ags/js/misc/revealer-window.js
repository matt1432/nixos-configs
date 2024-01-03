/**
 * This is the old version of my popup windows.
 * I don't use it anymore but I will keep it in
 * case my new one breaks or simply as an example.
 */

import App from 'resource:///com/github/Aylur/ags/app.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

import { Revealer, Box, Window } from 'resource:///com/github/Aylur/ags/widget.js';
import { timeout } from 'resource:///com/github/Aylur/ags/utils.js';

/**
 * @typedef {import('types/widgets/revealer').RevealerProps} RevProps
 * @typedef {import('types/widgets/window').WindowProps} WinProps
 * @typedef {import('gi://Gtk').Gtk.Widget} Widget
 */


/**
 * @param {WinProps & {
 *      transition?: RevProps['transition']
 *      transition_duration?: RevProps['transition_duration']
 *      on_open?: function
 *      on_close?: function
 *      blur?: boolean
 * }} o
 */
export default ({
    transition = 'slide_down',
    transition_duration = 800,
    on_open = () => {/**/},
    on_close = () => {/**/},

    // Window props
    name,
    child = Box(),
    visible = false,
    layer = 'overlay',
    blur = false,
    ...props
}) => {
    const window = Window({
        name,
        layer,
        visible: false,
        ...props,

        attribute: {
            // @ts-expect-error
            get_child: () => window.child.children[0].child,

            /** @param {Widget} new_child */
            set_child: (new_child) => {
                // @ts-expect-error
                window.child.children[0].child = new_child;
                // @ts-expect-error
                window.child.children[0].show_all();
            },
        },

        setup: () => {
            // Add way to make window open on startup
            const id = App.connect('config-parsed', () => {
                if (visible) {
                    App.openWindow(String(name));
                }
                App.disconnect(id);
            });

            if (blur) {
                Hyprland.sendMessage('[[BATCH]] ' +
                    `keyword layerrule ignorealpha[0.97],${name}; ` +
                    `keyword layerrule blur,${name}`);
            }
        },

        // Wrapping the revealer inside a box is needed
        // to allocate some space for it even when not revealed
        child: Box({
            css: `
                min-height:1px;
                min-width:1px;
                padding: 1px;
            `,
            child: Revealer({
                transition,
                transition_duration,
                child,

                setup: (self) => {
                    self.hook(App, (_, currentName, isOpen) => {
                        if (currentName === name) {
                            self.reveal_child = isOpen;

                            if (isOpen) {
                                on_open(window);
                            }
                            else {
                                timeout(Number(transition_duration), () => {
                                    on_close(window);
                                });
                            }
                        }
                    });
                },
            }),
        }),
    });

    return window;
};

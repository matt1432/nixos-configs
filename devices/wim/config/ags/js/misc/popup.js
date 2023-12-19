import App from 'resource:///com/github/Aylur/ags/app.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

import { Revealer, Box, Window } from 'resource:///com/github/Aylur/ags/widget.js';
import { timeout } from 'resource:///com/github/Aylur/ags/utils.js';

/**
 * @typedef {import('types/widgets/revealer').RevealerProps} RevProp
 * @typedef {import('types/widgets/window').WindowProps} WinProp
 */


/**
 * @param {WinProp & {
 *      transition?: RevProp['transition']
 *      transition_duration?: RevProp['transition_duration']
 *      onOpen?: function
 *      onClose?: function
 *      blur?: boolean
 *      close_on_unfocus?: 'none'|'stay'|'released'|'clicked'
 * }} o
 */
export default ({
    transition = 'slide_down',
    transition_duration = 500,
    onOpen = () => { /**/ },
    onClose = () => { /**/ },

    // Window props
    name,
    child,
    visible = false,
    layer = 'overlay',
    blur = false,
    close_on_unfocus = 'released',
    ...props
}) => {
    const window = Window({
        name,
        layer,
        visible: false,
        ...props,

        attribute: {
            set_x_pos: (
                alloc = {},
                side = 'right',
            ) => {
                const width = window.get_display()
                    .get_monitor_at_point(alloc.x, alloc.y)
                    .get_geometry().width;

                window.margins = [
                    window.margins[0],

                    side === 'right' ?
                        (width - alloc.x - alloc.width) :
                        window.margins[1],

                    window.margins[2],

                    side === 'right' ?
                        window.margins[3] :
                        (alloc.x - alloc.width),
                ];
            },

            // @ts-expect-error
            get_child: () => window.child.children[0].child,

            set_child: (newChild) => {
                // @ts-expect-error
                window.child.children[0].child = newChild;
                // @ts-expect-error
                window.child.children[0].show_all();
            },

            // This is for my custom pointers.js
            close_on_unfocus,
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

                setup: (self) => {
                    self.hook(App, (_, currentName, isOpen) => {
                        if (currentName === name) {
                            self.reveal_child = isOpen;

                            if (isOpen) {
                                onOpen(window);
                            }
                            else {
                                timeout(Number(transition_duration), () => {
                                    onClose(window);
                                });
                            }
                        }
                    });
                },

                child: child || Box(),
            }),
        }),
    });

    return window;
};

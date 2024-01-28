import App from 'resource:///com/github/Aylur/ags/app.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';

import { Box, Overlay, Window } from 'resource:///com/github/Aylur/ags/widget.js';
import { timeout } from 'resource:///com/github/Aylur/ags/utils.js';

// Types
import { Allocation, Widget } from 'types/@girs/gtk-3.0/gtk-3.0.cjs';
import { RevealerProps } from 'types/widgets/revealer';
import { WindowProps } from 'types/widgets/window';
import AgsWindow from 'types/widgets/window';
import AgsBox from 'types/widgets/box';
import AgsOverlay from 'types/widgets/overlay';
import { Binding } from 'types/service';
type PopupWindow = WindowProps & {
    transition?: RevealerProps['transition']
    transition_duration?: number
    bezier?: string
    on_open?(self: AgsWindow): void
    on_close?(self: AgsWindow): void
    blur?: boolean
    close_on_unfocus?: 'none' | 'stay' | 'released' | 'clicked'
    anchor?: Array<string>
    name: string
};

// FIXME: deal with overlay children?
// TODO: make this a new class to be able to edit props

export default ({
    transition = 'slide_down',
    transition_duration = 800,
    bezier = 'cubic-bezier(0.68, -0.4, 0.32, 1.4)',
    on_open = () => {/**/},
    on_close = () => {/**/},

    // Window props
    name,
    child = Box(),
    visible = false,
    anchor = [],
    layer = 'overlay',
    blur = false,
    close_on_unfocus = 'released',
    ...props
}: PopupWindow) => {
    const Child = Variable(child);
    const AntiClip = Variable(false);

    const needsAnticlipping = bezier.match(/-[0-9]/) !== null &&
        transition !== 'crossfade';

    const attribute = {
        set_x_pos: (
            alloc: Allocation,
            side = 'right' as 'left' | 'right',
        ) => {
            const window = App.getWindow(name) as AgsWindow;

            if (!window) {
                return;
            }

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

        get_child: () => Child.value,

        set_child: (new_child: Widget) => {
            Child.value = new_child;
            App.getWindow(name)?.child.show_all();
        },

        // This is for my custom pointers.ts
        close_on_unfocus,
    };

    if (transition === 'none') {
        return Window({
            name,
            layer,
            anchor,
            visible: false,
            ...props,
            attribute,
            child: Child.bind(),
        });
    }

    const window = Window({
        name,
        layer,
        anchor,
        visible: false,
        ...props,

        attribute,

        setup: () => {
            // Add way to make window open on startup
            const id = App.connect('config-parsed', () => {
                if (visible) {
                    App.openWindow(`${name}`);
                }
                App.disconnect(id);
            });

            if (blur) {
                Hyprland.sendMessage('[[BATCH]] ' +
                    `keyword layerrule ignorealpha[0.97],${name}; ` +
                    `keyword layerrule blur,${name}`);
            }
        },

        child: Overlay({
            overlays: [Box({
                css: `
                    min-height: 1px;
                    min-width: 1px;
                    padding: 1px;
                `,
                setup: (self) => {
                    // Make sure child doesn't
                    // get bigger than it should
                    const MAX_ANCHORS = 4;

                    self.hpack = 'center';
                    self.vpack = 'center';

                    if (anchor.includes('top') &&
                            anchor.includes('bottom')) {
                        self.vpack = 'center';
                    }
                    else if (anchor.includes('top')) {
                        self.vpack = 'start';
                    }
                    else if (anchor.includes('bottom')) {
                        self.vpack = 'end';
                    }

                    if (anchor.includes('left') &&
                            anchor.includes('right')) {
                        self.hpack = 'center';
                    }
                    else if (anchor.includes('left')) {
                        self.hpack = 'start';
                    }
                    else if (anchor.includes('right')) {
                        self.hpack = 'end';
                    }

                    if (anchor.length === MAX_ANCHORS) {
                        self.hpack = 'center';
                        self.vpack = 'center';
                    }

                    if (needsAnticlipping) {
                        const reorder_child = (position: number) => {
                            // If unanchored, we have another anticlip widget
                            // so we can't change the order
                            if (anchor.length !== 0) {
                                for (const ch of self.children) {
                                    if (ch !== Child.value) {
                                        self.reorder_child(ch, position);

                                        return;
                                    }
                                }
                            }
                        };

                        self.hook(AntiClip, () => {
                            if (transition === 'slide_down') {
                                self.vertical = true;
                                reorder_child(-1);
                            }
                            else if (transition === 'slide_up') {
                                self.vertical = true;
                                reorder_child(0);
                            }
                            else if (transition === 'slide_right') {
                                self.vertical = false;
                                reorder_child(-1);
                            }
                            else if (transition === 'slide_left') {
                                self.vertical = false;
                                reorder_child(0);
                            }
                        });
                    }
                },

                children: Child.bind().transform((v) => {
                    if (needsAnticlipping) {
                        return [
                            // Add an anticlip widget when unanchored
                            // to not have a weird animation
                            anchor.length === 0 && Box({
                                css: `
                                    min-height: 100px;
                                    min-width: 100px;
                                    padding: 2px;
                                `,
                                visible: AntiClip.bind(),
                            }),
                            v,
                            Box({
                                css: `
                                    min-height: 100px;
                                    min-width: 100px;
                                    padding: 2px;
                                `,
                                visible: AntiClip.bind(),
                            }),
                        ];
                    }
                    else {
                        return [v];
                    }
                }) as Binding<any, any, Widget[]>,
            })],

            setup: (self) => {
                self.on('get-child-position', (_, ch) => {
                    const overlay = (Child.value as Widget)
                        .get_parent() as AgsOverlay;

                    if (ch === overlay) {
                        const alloc = overlay.get_allocation();

                        (self.child as AgsBox).css = `
                            min-height: ${alloc.height}px;
                            min-width:  ${alloc.width}px;
                        `;
                    }
                });
            },

            child: Box({
                css: `
                    min-height: 1px;
                    min-width: 1px;
                    padding: 1px;
                `,

                setup: (self) => {
                    let currentTimeout: number;

                    self.hook(App, (_, currentName, isOpen) => {
                        if (currentName === name) {
                            const overlay = (Child.value as Widget)
                                .get_parent() as AgsOverlay;

                            const alloc = overlay.get_allocation();
                            const height = needsAnticlipping ?
                                alloc.height + 100 + 10 :
                                alloc.height + 10;

                            if (needsAnticlipping) {
                                AntiClip.value = true;

                                const thisTimeout = timeout(
                                    transition_duration,
                                    () => {
                                        // Only run the timeout if there isn't a newer timeout
                                        if (thisTimeout === currentTimeout) {
                                            AntiClip.value = false;
                                        }
                                    },
                                );

                                currentTimeout = thisTimeout;
                            }

                            let css = '';

                            /* Margin: top | right | bottom | left */
                            switch (transition) {
                                case 'slide_down':
                                    css = `margin:
                                        -${height}px
                                        0
                                        ${height}px
                                        0
                                    ;`;
                                    break;

                                case 'slide_up':
                                    css = `margin:
                                        ${height}px
                                        0
                                        -${height}px
                                        0
                                    ;`;
                                    break;

                                case 'slide_left':
                                    css = `margin:
                                        0
                                        -${height}px
                                        0
                                        ${height}px
                                    ;`;
                                    break;

                                case 'slide_right':
                                    css = `margin:
                                        0
                                        ${height}px
                                        0
                                        -${height}px
                                    ;`;
                                    break;

                                case 'crossfade':
                                    css = `
                                        opacity: 0;
                                        min-height: 1px;
                                        min-width: 1px;
                                    `;
                                    break;

                                default:
                                    break;
                            }

                            if (isOpen) {
                                on_open(window);

                                // To get the animation, we need to set the css
                                // to hide the widget and then timeout to have
                                // the animation
                                overlay.css = css;
                                timeout(10, () => {
                                    overlay.css = `
                                        transition: margin
                                            ${transition_duration}ms ${bezier},

                                                    opacity
                                            ${transition_duration}ms ${bezier};
                                    `;
                                });
                            }
                            else {
                                timeout(transition_duration, () => {
                                    on_close(window);
                                });

                                overlay.css = `${css}
                                    transition: margin
                                        ${transition_duration}ms ${bezier},

                                                opacity
                                        ${transition_duration}ms ${bezier};
                                `;
                            }
                        }
                    });
                },
            }),
        }),
    });

    return window;
};

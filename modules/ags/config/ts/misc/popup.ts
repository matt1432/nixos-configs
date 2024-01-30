import Gtk from 'gi://Gtk?version=3.0';
const Hyprland = await Service.import('hyprland');

const { Box, Overlay, register } = Widget;

const { timeout } = Utils;

// Types
import { Window } from 'resource:///com/github/Aylur/ags/widgets/window.js';
import { Variable as Var } from 'types/variable';

import {
    CloseType,
    BoxGeneric,
    OverlayGeneric,
    PopupChild,
    PopupWindowProps,
} from 'global-types';

// FIXME: deal with overlay children?
// TODO: make props changes affect the widget


export class PopupWindow<
    Child extends Gtk.Widget,
    Attr,
> extends Window<Child, Attr> {
    static {
        register(this, {
            properties: {
                content: ['widget', 'rw'],
            },
        });
    }

    #content: Var<Gtk.Widget>;
    #antiClip: Var<boolean>;
    #needsAnticlipping: boolean;
    #close_on_unfocus: CloseType;

    get content() {
        return this.#content.value;
    }

    set content(value: Gtk.Widget) {
        this.#content.value = value;
        this.child.show_all();
    }

    get close_on_unfocus() {
        return this.#close_on_unfocus;
    }

    set close_on_unfocus(value: 'none' | 'stay' | 'released' | 'clicked') {
        this.#close_on_unfocus = value;
    }

    constructor({
        transition = 'slide_down',
        transition_duration = 800,
        bezier = 'cubic-bezier(0.68, -0.4, 0.32, 1.4)',
        on_open = () => {/**/},
        on_close = () => {/**/},

        // Window props
        name,
        visible = false,
        anchor = [],
        layer = 'overlay',
        attribute,
        content = Box(),
        blur = false,
        close_on_unfocus = 'released',
        ...rest
    }: PopupWindowProps<Child, Attr>) {
        const needsAnticlipping = bezier.match(/-[0-9]/) !== null &&
            transition !== 'crossfade';
        const contentVar = Variable(Box() as Gtk.Widget);
        const antiClip = Variable(false);

        if (content) {
            contentVar.value = content;
        }

        super({
            ...rest,
            name,
            visible,
            anchor,
            layer,
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
                                        if (ch !== contentVar.value) {
                                            self.reorder_child(ch, position);

                                            return;
                                        }
                                    }
                                }
                            };

                            self.hook(antiClip, () => {
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

                    children: contentVar.bind().transform((v) => {
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
                                    visible: antiClip.bind(),
                                }),
                                v,
                                Box({
                                    css: `
                                        min-height: 100px;
                                        min-width: 100px;
                                        padding: 2px;
                                    `,
                                    visible: antiClip.bind(),
                                }),
                            ];
                        }
                        else {
                            return [v];
                        }
                    }) as PopupChild,
                })],

                setup: (self) => {
                    self.on('get-child-position', (_, ch) => {
                        const overlay = contentVar.value
                            .get_parent() as OverlayGeneric;

                        if (ch === overlay) {
                            const alloc = overlay.get_allocation();

                            (self.child as BoxGeneric).css = `
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
                                const overlay = contentVar.value
                                    .get_parent() as OverlayGeneric;

                                const alloc = overlay.get_allocation();
                                const height = antiClip ?
                                    alloc.height + 100 + 10 :
                                    alloc.height + 10;

                                if (needsAnticlipping) {
                                    antiClip.value = true;

                                    const thisTimeout = timeout(
                                        transition_duration,
                                        () => {
                                            // Only run the timeout if there isn't a newer timeout
                                            if (thisTimeout ===
                                                currentTimeout) {
                                                antiClip.value = false;
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
                                    on_open(this);

                                    // To get the animation, we need to set the css
                                    // to hide the widget and then timeout to have
                                    // the animation
                                    overlay.css = css;
                                    timeout(10, () => {
                                        overlay.css = `
                                            transition: margin
                                                ${transition_duration}ms
                                                ${bezier},

                                                        opacity
                                                ${transition_duration}ms
                                                ${bezier};
                                        `;
                                    });
                                }
                                else {
                                    timeout(transition_duration, () => {
                                        on_close(this);
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

        this.#content = contentVar;
        this.#close_on_unfocus = close_on_unfocus;
        this.#needsAnticlipping = needsAnticlipping;
        this.#antiClip = antiClip;
    }

    set_x_pos(
        alloc: Gtk.Allocation,
        side = 'right' as 'left' | 'right',
    ) {
        const width = this.get_display()
            .get_monitor_at_point(alloc.x, alloc.y)
            .get_geometry().width;

        this.margins = [
            this.margins[0],

            side === 'right' ?
                (width - alloc.x - alloc.width) :
                this.margins[1],

            this.margins[2],

            side === 'right' ?
                this.margins[3] :
                (alloc.x - alloc.width),
        ];
    }
}

export default <Child extends Gtk.Widget, Attr>(
    props: PopupWindowProps<Child, Attr>,
) => new PopupWindow(props);

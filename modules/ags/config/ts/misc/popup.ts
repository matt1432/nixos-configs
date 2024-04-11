import Gtk from 'gi://Gtk?version=3.0';
const Hyprland = await Service.import('hyprland');

/* Types */
import { Window } from 'resource:///com/github/Aylur/ags/widgets/window.js';

import {
    CloseType,
    HyprTransition,
    PopupWindowProps,
} from 'global-types';


export class PopupWindow<
    Child extends Gtk.Widget,
    Attr,
> extends Window<Child, Attr> {
    static {
        Widget.register(this, {
            properties: {
                close_on_unfocus: ['string', 'rw'],
                transition: ['string', 'rw'],
            },
        });
    }

    #close_on_unfocus: CloseType;
    #transition: HyprTransition;

    get close_on_unfocus() {
        return this.#close_on_unfocus;
    }

    set close_on_unfocus(value: CloseType) {
        this.#close_on_unfocus = value;
    }

    get transition() {
        return this.#transition;
    }

    set transition(t: HyprTransition) {
        this.#transition = t;
        Hyprland.messageAsync(`keyword layerrule animation ${t}, ${this.name}`);
    }

    constructor({
        transition = 'slide top',
        on_open = () => {/**/},
        on_close = () => {/**/},

        // Window props
        name,
        visible = false,
        anchor = [],
        layer = 'overlay',
        close_on_unfocus = 'released',
        ...rest
    }: PopupWindowProps<Child, Attr>) {
        super({
            ...rest,
            name: `win-${name}`,
            visible,
            anchor,
            layer,
            setup: () => {
                const id = App.connect('config-parsed', () => {
                    // Add way to make window open on startup
                    if (visible) {
                        App.openWindow(`win-${name}`);
                    }

                    // This connection should always run only once
                    App.disconnect(id);
                });

                Hyprland.messageAsync(
                    `keyword layerrule animation ${transition}, win-${name}`,
                );
            },
        });

        this.hook(App, (_, currentName, isOpen) => {
            if (currentName === `win-${name}`) {
                if (isOpen) {
                    on_open(this);
                }
                else {
                    on_close(this);
                }
            }
        });

        this.#close_on_unfocus = close_on_unfocus;
        this.#transition = transition;
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

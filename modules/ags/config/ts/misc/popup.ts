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


    private _close_on_unfocus: CloseType;

    get close_on_unfocus() {
        return this._close_on_unfocus;
    }

    set close_on_unfocus(value: CloseType) {
        this._close_on_unfocus = value;
    }


    private _transition = 'unset' as HyprTransition;

    get transition() {
        return this._transition;
    }

    set transition(t: HyprTransition) {
        Hyprland.messageAsync(
            `keyword layerrule animation ${t}, ${this.name}`,
        ).catch(logError);
        this._transition = t;
    }


    private _on_open: (self: PopupWindow<Child, Attr>) => void;

    get on_open() {
        return this._on_open;
    }

    set on_open(fun: (self: PopupWindow<Child, Attr>) => void) {
        this._on_open = fun;
    }


    private _on_close: (self: PopupWindow<Child, Attr>) => void;

    get on_close() {
        return this._on_close;
    }

    set on_close(fun: (self: PopupWindow<Child, Attr>) => void) {
        this._on_close = fun;
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
            },
        });

        this._close_on_unfocus = close_on_unfocus;
        this._on_open = on_open;
        this._on_close = on_close;

        this.hook(App, (_, currentName, isOpen) => {
            if (currentName === `win-${name}`) {
                // Make sure we have the right animation
                this.transition = transition;

                if (isOpen) {
                    this.on_open(this);
                }
                else {
                    this.on_close(this);
                }
            }
        });
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

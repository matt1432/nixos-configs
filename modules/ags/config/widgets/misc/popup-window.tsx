import { App, Astal, Gtk, Widget } from 'astal/gtk3';
import { property, register } from 'astal/gobject';
import { Binding, idle } from 'astal';

/* Types */
type CloseType = 'none' | 'stay' | 'released' | 'clicked';
type HyprTransition = 'slide' | 'slide top' | 'slide bottom' | 'slide left' |
    'slide right' | 'popin' | 'fade';
type PopupCallback = (self?: Widget.Window) => void;

export type PopupWindowProps = Widget.WindowProps & {
    transition?: HyprTransition | Binding<HyprTransition>
    close_on_unfocus?: CloseType | Binding<CloseType>
    on_open?: PopupCallback
    on_close?: PopupCallback
};


@register()
export class PopupWindow extends Widget.Window {
    @property(String)
    declare close_on_unfocus: CloseType | Binding<CloseType>;

    on_open: PopupCallback;
    on_close: PopupCallback;

    constructor({
        transition = 'slide top',
        close_on_unfocus = 'released',
        on_open = () => { /**/ },
        on_close = () => { /**/ },

        name,
        visible = false,
        layer = Astal.Layer.OVERLAY,
        ...rest
    }: PopupWindowProps) {
        let namePrefix = 'win-';

        switch (transition) {
            case 'fade':
                namePrefix += 'fade-';
                break;

            case 'popin':
                namePrefix += 'popin-';
                break;

            case 'slide':
                namePrefix += 'slide-';
                break;

            case 'slide top':
                namePrefix += 'top-';
                break;

            case 'slide left':
                namePrefix += 'left-';
                break;

            case 'slide right':
                namePrefix += 'right-';
                break;

            case 'slide bottom':
                namePrefix += 'bottom-';
                break;
        }

        super({
            ...rest,
            name: `win-${name}`,
            namespace: `${namePrefix}${name}`,
            visible: false,
            layer,
            setup: () => idle(() => {
                // Add way to make window open on startup
                if (visible) {
                    this.visible = true;
                }
            }),
        });

        App.add_window(this);

        this.close_on_unfocus = close_on_unfocus;
        this.on_open = on_open;
        this.on_close = on_close;

        this.connect('notify::visible', () => {
            if (this.visible) {
                this.on_open(this);
            }
            else {
                this.on_close(this);
            }
        });
    };

    async set_x_pos(
        alloc: Gtk.Allocation,
        side = 'right' as 'left' | 'right',
    ) {
        const monitor = this.gdkmonitor ??
            this.get_display().get_monitor_at_point(alloc.x, alloc.y);

        const width = monitor.get_geometry().width;

        this.margin_right = side === 'right' ?
            (width - alloc.x - alloc.width) :
            this.margin_right;

        this.margin_left = side === 'right' ?
            this.margin_left :
            (alloc.x - alloc.width);
    }
}

export default PopupWindow;

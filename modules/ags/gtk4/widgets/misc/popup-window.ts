import { App, Astal, Gtk } from 'astal/gtk4';
import { property, register } from 'astal/gobject';
import { Binding, idle } from 'astal';

import { WindowClass, WindowProps } from '../subclasses';
import { get_hyprland_monitor } from '../../lib';

/* Types */
type CloseType = 'none' | 'stay' | 'released' | 'clicked';
type HyprTransition = 'slide' | 'slide top' | 'slide bottom' | 'slide left' |
    'slide right' | 'popin' | 'fade';
type PopupCallback = (self?: WindowClass) => void;

export type PopupWindowProps = WindowProps & {
    transition?: HyprTransition | Binding<HyprTransition>
    close_on_unfocus?: CloseType | Binding<CloseType>
    on_open?: PopupCallback
    on_close?: PopupCallback
};


@register()
export class PopupWindow extends WindowClass {
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
        let finalName = `win-${name}`;

        switch (transition) {
            case 'fade':
                finalName += '-fade';
                break;

            case 'popin':
                finalName += '-popin';
                break;

            case 'slide':
                finalName += '-slide';
                break;

            case 'slide top':
                finalName += '-top';
                break;

            case 'slide left':
                finalName += '-left';
                break;

            case 'slide right':
                finalName += '-right';
                break;

            case 'slide bottom':
                finalName += '-bottom';
                break;
        }

        super({
            ...rest,
            name: `win-${name}`,
            namespace: finalName,
            visible: false,
            layer,
            setup: () => idle(() => {
                // Add way to make window open on startup
                if (visible) {
                    this.visible = true;
                }
            }),
        } as WindowProps);

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
        const monitor = this.gdkmonitor ?? this.get_current_monitor();

        const transform = get_hyprland_monitor(monitor)?.get_transform();

        let width: number;

        if (transform && (transform === 1 || transform === 3)) {
            width = monitor.get_geometry().height;
        }
        else {
            width = monitor.get_geometry().width;
        }

        this.margin_right = side === 'right' ?
            (width - alloc.x - alloc.width) :
            this.margin_right;

        this.margin_left = side === 'right' ?
            this.margin_left :
            (alloc.x - alloc.width);
    }
}

export default PopupWindow;

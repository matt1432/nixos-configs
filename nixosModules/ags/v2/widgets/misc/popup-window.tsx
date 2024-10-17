import { App, Astal, Widget } from 'astal/gtk3';
import { register, property } from 'astal/gobject';
import { Binding, idle } from 'astal';

import { hyprMessage } from '../../lib';

/* Types */
type CloseType = 'none' | 'stay' | 'released' | 'clicked';
type HyprTransition = 'slide' | 'slide top' | 'slide bottom' | 'slide left' |
    'slide right' | 'popin' | 'fade';
type PopupCallback = (self: PopupWindow) => void;

type PopupWindowProps = Widget.WindowProps & {
    transition?: HyprTransition | Binding<HyprTransition>
    close_on_unfocus?: CloseType | Binding<CloseType>
    on_open?: PopupCallback
    on_close?: PopupCallback
};


@register()
export class PopupWindow extends Widget.Window {
    @property(String)
    declare transition: HyprTransition | Binding<HyprTransition>;

    @property(String)
    declare close_on_unfocus: CloseType | Binding<CloseType>;

    @property(Object)
    declare on_open: PopupCallback;

    @property(Object)
    declare on_close: PopupCallback;

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
        super({
            ...rest,
            name: `win-${name}`,
            namespace: `win-${name}`,
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

        const setTransition = (_: PopupWindow, t: HyprTransition | Binding<HyprTransition>) => {
            hyprMessage(`keyword layerrule animation ${t}, ${this.name}`);
        };

        this.connect('notify::transition', setTransition);

        this.close_on_unfocus = close_on_unfocus;
        this.transition = transition;
        this.on_open = on_open;
        this.on_close = on_close;

        this.connect('notify::visible', () => {
            // Make sure we have the right animation
            setTransition(this, this.transition);

            if (this.visible) {
                this.on_open(this);
            }
            else {
                this.on_close(this);
            }
        });
    };
}

export default (props: PopupWindowProps) => new PopupWindow(props);

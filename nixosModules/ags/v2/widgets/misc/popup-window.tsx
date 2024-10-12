import { Astal, Binding, idle, Widget } from 'astal';
import { register, property } from 'astal/gobject';

import AstalHyprland from 'gi://AstalHyprland?version=0.1';
const Hyprland = AstalHyprland.get_default();

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
class PopupWindow extends Widget.Window {
    @property(String)
    declare transition: HyprTransition | Binding<HyprTransition>;

    @property(String)
    declare close_on_unfocus: CloseType | Binding<CloseType>;

    @property(Object)
    declare on_open: PopupCallback;

    @property(Object)
    declare on_close: PopupCallback;

    constructor({
        transition = 'fade',
        close_on_unfocus = 'none',
        on_open = () => { /**/ },
        on_close = () => { /**/ },

        name,
        visible = false,
        layer = Astal.Layer.OVERLAY,
        ...rest
    }: PopupWindowProps) {
        super({
            ...rest,
            name,
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

        const setTransition = (_: PopupWindow, t: HyprTransition | Binding<HyprTransition>) => {
            Hyprland.message_async(
                `keyword layerrule animation ${t}, ${this.name}`,
                () => { /**/ },
            );
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

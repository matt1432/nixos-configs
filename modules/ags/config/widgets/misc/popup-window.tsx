import { property, register } from 'ags/gobject';
import { Astal, Gtk } from 'ags/gtk3';
import app from 'ags/gtk3/app';
import { idle } from 'ags/time';

import { hyprMessage } from '../../lib';

type CloseType = 'none' | 'stay' | 'released' | 'clicked';
type HyprTransition =
    | 'slide'
    | 'slide top'
    | 'slide bottom'
    | 'slide left'
    | 'slide right'
    | 'popin'
    | 'fade';
type PopupCallback = (self?: Astal.Window) => void;

export type PopupWindowProps = Partial<Astal.Window.ConstructorProps> & {
    transition?: HyprTransition;
    closeOnUnfocus?: CloseType;
    openCallback?: PopupCallback;
    closeCallback?: PopupCallback;
};

@register()
export class PopupWindow extends Astal.Window {
    @property(String) transition: HyprTransition;

    @property(String) closeOnUnfocus: CloseType;

    openCallback: PopupCallback;
    closeCallback: PopupCallback;

    constructor({
        transition = 'slide top',
        closeOnUnfocus = 'released',
        openCallback = () => {},
        closeCallback = () => {},

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
        });
        idle(() => {
            // Adds way to make window closed on startup
            if (!visible) {
                this.visible = false;
            }
        });

        app.add_window(this);

        const setTransition = (_: PopupWindow, t: HyprTransition) => {
            hyprMessage(
                `keyword layerrule animation ${t}, match:namespace ${this.name}`,
            ).catch(console.log);
        };

        this.connect('notify::transition', setTransition);

        this.closeOnUnfocus = closeOnUnfocus;
        this.transition = transition;
        this.openCallback = openCallback;
        this.closeCallback = closeCallback;

        this.connect('notify::visible', () => {
            // Make sure we have the right animation
            setTransition(this, this.transition);

            if (this.visible) {
                this.openCallback(this);
            }
            else {
                this.closeCallback(this);
            }
        });
    }

    async set_x_pos(alloc: Gtk.Allocation, side = 'right' as 'left' | 'right') {
        const monitor =
            this.gdkmonitor ??
            this.get_display().get_monitor_at_point(alloc.x, alloc.y);

        const width = monitor.get_geometry().width;

        this.margin_right =
            side === 'right'
                ? width - alloc.x - alloc.width
                : this.margin_right;

        this.margin_left =
            side === 'right' ? this.margin_left : alloc.x - alloc.width;
    }
}

export default PopupWindow;

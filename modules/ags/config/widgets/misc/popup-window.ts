import { property, register } from 'ags/gobject';
import { Astal, Gtk } from 'ags/gtk4';
import app from 'ags/gtk4/app';
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
    close_on_unfocus?: CloseType;
    open_callback?: PopupCallback;
    close_callback?: PopupCallback;
};

@register()
export class PopupWindow extends Astal.Window {
    @property(String) transition: HyprTransition;

    @property(String) close_on_unfocus: CloseType;

    open_callback: PopupCallback;
    close_callback: PopupCallback;

    constructor({
        transition = 'slide top',
        close_on_unfocus = 'released',
        open_callback = () => {},
        close_callback = () => {},

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
            // Adds way to make window open on startup
            if (visible) {
                this.visible = true;
            }
        });

        app.add_window(this);

        const setTransition = (_: PopupWindow, t: HyprTransition) => {
            hyprMessage(
                `eval hl.layer_rule({animation="${t}",match={namespace="${this.name}"}})`,
            ).catch(console.log);
        };

        this.connect('notify::transition', () => {
            setTransition(this, this.transition);
        });

        this.close_on_unfocus = close_on_unfocus;
        this.transition = transition;
        this.open_callback = open_callback;
        this.close_callback = close_callback;

        this.connect('notify::visible', () => {
            // Make sure we have the right animation
            setTransition(this, this.transition);

            if (this.visible) {
                this.open_callback(this);
            }
            else {
                this.close_callback(this);
            }
        });
    }

    /**
     * Aligns this popup horizontally with a widget of another window
     * (usually a bar item).
     *
     * @param widget the widget to align with
     * @param side   which edge of the popup to align
     */
    set_x_pos(widget: Gtk.Widget, side = 'right' as 'left' | 'right') {
        const root = widget.get_root() as Gtk.Widget | null;
        const [ok, bounds] = root ? widget.compute_bounds(root) : [false];

        if (!ok || !bounds) {
            return;
        }

        const x = bounds.get_x();
        const w = bounds.get_width();

        // This popup is usually not mapped yet, so get the monitor from the
        // anchor widget's window instead. Layer surfaces don't always report
        // the monitor they're on, so prefer the window's own monitor.
        const surface = widget.get_native()?.get_surface();
        const monitor =
            this.gdkmonitor ??
            (root instanceof Astal.Window ? root.gdkmonitor : null) ??
            (surface && widget.get_display().get_monitor_at_surface(surface));

        if (!monitor) {
            return;
        }

        const width = monitor.get_geometry().width;

        this.margin_right =
            side === 'right' ? width - x - w : this.margin_right;

        this.margin_left = side === 'right' ? this.margin_left : x - w;
    }
}

export default PopupWindow;

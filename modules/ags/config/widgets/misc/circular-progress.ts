import { getter, register, setter } from 'ags/gobject';
import { Gdk, Gtk } from 'ags/gtk4';

/*
 * Replacement for Astal3's CircularProgress, which has no GTK4 equivalent.
 *
 * GTK4 doesn't let us read background colors from CSS, so the progress arc
 * uses the CSS `color` and the trough uses the `trough_color` property.
 */

type CircularProgressProps = Partial<
    Gtk.DrawingArea.ConstructorProps & {
        value: number;
        start_at: number;
        end_at: number;
        rounded: boolean;
        thickness: number;
        trough_color: string;
    }
>;

@register({ CssName: 'circularprogress' })
export class CircularProgress extends Gtk.DrawingArea {
    private _value = 0;
    private _start_at = 0;
    private _end_at = 0;
    private _rounded = false;
    private _thickness = 4;
    private _trough_color = '#363847';

    @getter(Number)
    get value() {
        return this._value;
    }

    @setter(Number)
    set value(v: number) {
        this._value = v;
        this.queue_draw();
        this.notify('value');
    }

    @getter(Number)
    get start_at() {
        return this._start_at;
    }

    @setter(Number)
    set start_at(v: number) {
        this._start_at = v;
        this.queue_draw();
        this.notify('start-at');
    }

    @getter(Number)
    get end_at() {
        return this._end_at;
    }

    @setter(Number)
    set end_at(v: number) {
        this._end_at = v;
        this.queue_draw();
        this.notify('end-at');
    }

    @getter(Boolean)
    get rounded() {
        return this._rounded;
    }

    @setter(Boolean)
    set rounded(v: boolean) {
        this._rounded = v;
        this.queue_draw();
        this.notify('rounded');
    }

    @getter(Number)
    get thickness() {
        return this._thickness;
    }

    @setter(Number)
    set thickness(v: number) {
        this._thickness = v;
        this.queue_draw();
        this.notify('thickness');
    }

    @getter(String)
    get trough_color() {
        return this._trough_color;
    }

    @setter(String)
    set trough_color(v: string) {
        this._trough_color = v;
        this.queue_draw();
        this.notify('trough-color');
    }

    constructor({
        value = 0,
        start_at = 0,
        end_at = 0,
        rounded = false,
        thickness = 4,
        trough_color = '#363847',
        ...props
    }: CircularProgressProps = {}) {
        super(props);

        // Set after super(): class field initializers run after the GObject
        // constructor and would overwrite values passed to it
        this.value = value;
        this.start_at = start_at;
        this.end_at = end_at;
        this.rounded = rounded;
        this.thickness = thickness;
        this.trough_color = trough_color;

        this.set_draw_func((_, cr, width, height) => {
            const size = Math.min(width, height);
            const radius = (size - this._thickness) / 2;
            const cx = width / 2;
            const cy = height / 2;

            const fullCircle = this._start_at === this._end_at;
            const start = this._start_at * 2 * Math.PI;
            let end = this._end_at * 2 * Math.PI;

            if (end <= start) {
                end += 2 * Math.PI;
            }

            const progressEnd =
                start + (end - start) * Math.min(Math.max(this._value, 0), 1);

            const trough = new Gdk.RGBA();

            trough.parse(this._trough_color);

            cr.setLineWidth(this._thickness);

            // Trough
            cr.setSourceRGBA(
                trough.red,
                trough.green,
                trough.blue,
                trough.alpha,
            );

            if (fullCircle) {
                cr.arc(cx, cy, radius, 0, 2 * Math.PI);
            }
            else {
                cr.arc(cx, cy, radius, start, end);
            }
            cr.stroke();

            // Progress
            if (this._value > 0) {
                const color = this.get_color();

                cr.setSourceRGBA(
                    color.red,
                    color.green,
                    color.blue,
                    color.alpha,
                );
                cr.setLineCap(this._rounded ? 1 : 0); // ROUND : BUTT
                cr.arc(cx, cy, radius, start, progressEnd);
                cr.stroke();
            }

            cr.$dispose?.();
        });
    }
}

export default CircularProgress;

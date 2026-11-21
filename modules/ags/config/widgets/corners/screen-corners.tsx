import { Gtk } from 'ags/gtk4';

const RADIUS = 8;

/*
 * GTK4 can't read the background color or border radius of a widget
 * from its style context, so the corner is filled with the CSS `color`.
 */
export default (place = 'top left', color = 'black') => (
    <box
        halign={place.includes('left') ? Gtk.Align.START : Gtk.Align.END}
        valign={place.includes('top') ? Gtk.Align.START : Gtk.Align.END}
        css={`
            padding: 1px;
            margin: ${place.includes('top') ? '-1px' : '0'}
                ${place.includes('right') ? '-1px' : '0'}
                ${place.includes('bottom') ? '-1px' : '0'}
                ${place.includes('left') ? '-1px' : '0'};
        `}
    >
        <drawingarea
            css={`
                color: ${color};
            `}
            widthRequest={RADIUS}
            heightRequest={RADIUS}
            $={(widget) => {
                widget.set_draw_func((_, cr) => {
                    const fg = widget.get_color();
                    const radius = RADIUS;

                    switch (place) {
                        case 'topleft':
                            cr.arc(
                                radius,
                                radius,
                                radius,
                                Math.PI,
                                (3 * Math.PI) / 2,
                            );
                            cr.lineTo(0, 0);
                            break;

                        case 'topright':
                            cr.arc(
                                0,
                                radius,
                                radius,
                                (3 * Math.PI) / 2,
                                2 * Math.PI,
                            );
                            cr.lineTo(radius, 0);
                            break;

                        case 'bottomleft':
                            cr.arc(radius, 0, radius, Math.PI / 2, Math.PI);
                            cr.lineTo(0, radius);
                            break;

                        case 'bottomright':
                            cr.arc(0, 0, radius, 0, Math.PI / 2);
                            cr.lineTo(radius, radius);
                            break;
                    }

                    cr.closePath();
                    cr.setSourceRGBA(fg.red, fg.green, fg.blue, fg.alpha);
                    cr.fill();
                });
            }}
        />
    </box>
);

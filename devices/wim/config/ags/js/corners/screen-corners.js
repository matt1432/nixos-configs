import { Box, DrawingArea } from 'resource:///com/github/Aylur/ags/widget.js';
import Gtk from 'gi://Gtk';
const Lang = imports.lang;

export default place => Box({
    hpack: place.includes('left') ? 'start' : 'end',
    vpack: place.includes('top')  ? 'start' : 'end',
    css: `
        padding: 1px; margin:
            ${place.includes('top')    ? '-1px' : '0'}
            ${place.includes('right')  ? '-1px' : '0'}
            ${place.includes('bottom') ? '-1px' : '0'}
            ${place.includes('left')   ? '-1px' : '0'};
        `,
    child: DrawingArea({
        css: `
            background-color: black;
            border-radius: 18px;
            border-width: 0.068rem;
        `,
        setup: widget => {
            const r = widget.get_style_context()
                .get_property('border-radius', Gtk.StateFlags.NORMAL);

            widget.set_size_request(r, r);
            widget.connect('draw', Lang.bind(widget, (widget, cr) => {
                const c = widget.get_style_context()
                    .get_property('background-color', Gtk.StateFlags.NORMAL);

                const r = widget.get_style_context()
                    .get_property('border-radius', Gtk.StateFlags.NORMAL);

                const borderColor = widget.get_style_context()
                    .get_property('color', Gtk.StateFlags.NORMAL);

                // ur going to write border-width: something anyway
                const borderWidth = widget.get_style_context()
                    .get_border(Gtk.StateFlags.NORMAL).left;
                widget.set_size_request(r, r);

                switch (place) {
                    case 'topleft':
                        cr.arc(r, r, r, Math.PI, 3 * Math.PI / 2);
                        cr.lineTo(0, 0);
                        break;

                    case 'topright':
                        cr.arc(0, r, r, 3 * Math.PI / 2, 2 * Math.PI);
                        cr.lineTo(r, 0);
                        break;

                    case 'bottomleft':
                        cr.arc(r, 0, r, Math.PI / 2, Math.PI);
                        cr.lineTo(0, r);
                        break;

                    case 'bottomright':
                        cr.arc(0, 0, r, 0, Math.PI / 2);
                        cr.lineTo(r, r);
                        break;
                }

                cr.closePath();
                cr.setSourceRGBA(c.red, c.green, c.blue, c.alpha);
                cr.fill();
                cr.setLineWidth(borderWidth);
                cr.setSourceRGBA(borderColor.red,
                    borderColor.green,
                    borderColor.blue,
                    borderColor.alpha);
                cr.stroke();
            }));
        },
    }),
});

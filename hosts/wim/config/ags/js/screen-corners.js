import { Widget } from '../imports.js';
const { Gtk } = imports.gi;
const Lang = imports.lang;

export const RoundedCorner = (place, props) => Widget({
    ...props,
    type: Gtk.DrawingArea,
    halign: place.includes('left') ? 'start' : 'end',
    valign: place.includes('top') ? 'start' : 'end',
    setup: widget => {
        const r = widget.get_style_context().get_property('border-radius', Gtk.StateFlags.NORMAL);
        widget.set_size_request(r, r);
        widget.connect('draw', Lang.bind(widget, (widget, cr) => {
            const c = widget.get_style_context().get_property('background-color', Gtk.StateFlags.NORMAL);
            const r = widget.get_style_context().get_property('border-radius', Gtk.StateFlags.NORMAL);
            const borderColor = widget.get_style_context().get_property('color', Gtk.StateFlags.NORMAL);
            const borderWidth = widget.get_style_context().get_border(Gtk.StateFlags.NORMAL).left; // ur going to write border-width: something anyway
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
            cr.setSourceRGBA(borderColor.red, borderColor.green, borderColor.blue, borderColor.alpha);
            cr.stroke();
        }));
    },
});

export const Topleft = () => Widget.Window({
    name: 'cornertl',
    layer: 'overlay',
    anchor: ['top', 'left'],
    exclusive: false,
    visible: true,
    child: RoundedCorner('topleft', { className: 'corner', }),
});
export const Topright = () => Widget.Window({
    name: 'cornertr',
    layer: 'overlay',
    anchor: ['top', 'right'],
    exclusive: false,
    visible: true,
    child: RoundedCorner('topright', { className: 'corner', }),
});
export const Bottomleft = () => Widget.Window({
    name: 'cornerbl',
    layer: 'overlay',
    anchor: ['bottom', 'left'],
    exclusive: false,
    visible: true,
    child: RoundedCorner('bottomleft', { className: 'corner', }),
});
export const Bottomright = () => Widget.Window({
    name: 'cornerbr',
    layer: 'overlay',
    anchor: ['bottom', 'right'],
    exclusive: false,
    visible: true,
    child: RoundedCorner('bottomright', { className: 'corner', }),
});

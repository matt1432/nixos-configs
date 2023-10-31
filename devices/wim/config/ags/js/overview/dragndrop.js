import App from 'resource:///com/github/Aylur/ags/app.js';
import { EventBox } from 'resource:///com/github/Aylur/ags/widget.js';
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

import Gtk from 'gi://Gtk';
import Gdk from 'gi://Gdk';
import Cairo from 'cairo';

import Button from '../misc/cursorbox.js';
import { updateClients } from './clients.js';

const TARGET = [Gtk.TargetEntry.new('text/plain', Gtk.TargetFlags.SAME_APP, 0)];


function createSurfaceFromWidget(widget) {
    const alloc = widget.get_allocation();
    const surface = new Cairo.ImageSurface(
        Cairo.Format.ARGB32,
        alloc.width,
        alloc.height,
    );
    const cr = new Cairo.Context(surface);
    cr.setSourceRGBA(255, 255, 255, 0);
    cr.rectangle(0, 0, alloc.width, alloc.height);
    cr.fill();
    widget.draw(cr);

    return surface;
}

let hidden = 0;
export const WorkspaceDrop = props => EventBox({
    ...props,
    connections: [['drag-data-received', (self, _c, _x, _y, data) => {
        let id = self.get_parent()._id;

        if (id < -1)
            id = self.get_parent()._name;

        else if (id === -1)
            id = `special:${++hidden}`;

        else if (id === 1000)
            id = 'empty';

        execAsync(`hyprctl dispatch movetoworkspacesilent ${id},address:${data.get_text()}`)
            .catch(print);
    }]],
    setup: self => {
        self.drag_dest_set(Gtk.DestDefaults.ALL, TARGET, Gdk.DragAction.COPY);
    },
});

export const WindowButton = ({ address, ...props } = {}) => Button({
    type: 'Button',
    ...props,
    setup: self => {
        self.drag_source_set(Gdk.ModifierType.BUTTON1_MASK, TARGET, Gdk.DragAction.COPY);
        self.connect('drag-data-get', (_w, _c, data) => {
            data.set_text(address, address.length);
        });
        self.connect('drag-begin', (_, context) => {
            Gtk.drag_set_icon_surface(context, createSurfaceFromWidget(self));
            self.get_parent().revealChild = false;
        });
        self.connect('drag-end', () => {
            self.get_parent().destroy();

            const mainBox = App.getWindow('overview').getChild();
            updateClients(mainBox.child);
        });
    },
});

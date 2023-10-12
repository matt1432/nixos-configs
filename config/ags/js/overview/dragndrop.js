import { App, Utils, Widget } from '../../imports.js';
const { EventBox } = Widget;
const { execAsync } = Utils;
const { getWindow } = App;

import Gtk from 'gi://Gtk';
import Gdk from 'gi://Gdk';
import Cairo from 'cairo';

import { Button } from '../misc/cursorbox.js';

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
};

let hidden = 0;
export const WorkspaceDrop = params => EventBox({
  ...params,
  connections: [['drag-data-received', (eventbox, _c, _x, _y, data) => {
    let id = eventbox.get_parent()._id;

    if (id < -1) {
      id = eventbox.get_parent()._name;
    }
    else if (id === -1) {
      id = `special:${++hidden}`;
    }
    else if (id === 1000) {
      id = "empty";
    }
    execAsync(`hyprctl dispatch movetoworkspacesilent ${id},address:${data.get_text()}`)
      .catch(print);
  }]],
  setup: eventbox => {
    eventbox.drag_dest_set(Gtk.DestDefaults.ALL, TARGET, Gdk.DragAction.COPY);
  },
});

export const WindowButton = ({address, ...params} = {}) => Button({
  ...params,
  setup: button => {
    button.drag_source_set(Gdk.ModifierType.BUTTON1_MASK, TARGET, Gdk.DragAction.COPY);
    button.connect('drag-data-get', (_w, _c, data) => {
      data.set_text(address, address.length);
    });
    button.connect('drag-begin', (_, context) => {
      Gtk.drag_set_icon_surface(context, createSurfaceFromWidget(button));
      button.get_parent().revealChild = false;
    });
    button.connect('drag-end', () => {
      button.get_parent().destroy();

      let mainBox = getWindow('overview').child.children[0].child;
      mainBox._updateClients(mainBox);
    });
  },
});

const { Gtk, Gdk } = imports.gi;
const { EventBox } = ags.Widget;
const { execAsync } = ags.Utils;
const { getWindow } = ags.App;
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

export const WorkspaceDrop = ({id, ...params} = {}) => EventBox({
  ...params,
  tooltipText: `Workspace: ${id}`,
  setup: eventbox => {
    eventbox.drag_dest_set(Gtk.DestDefaults.ALL, TARGET, Gdk.DragAction.COPY);
    eventbox.connect('drag-data-received', (_w, _c, _x, _y, data) => {
      execAsync(`hyprctl dispatch movetoworkspacesilent ${id},address:${data.get_text()}`)
        .catch(print);
    });
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
      let mainBox = getWindow('overview').child.child;
      mainBox._updateClients(mainBox);
    });
  },
});

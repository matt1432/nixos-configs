const { Window, Box, EventBox, Button } = ags.Widget;
const { Gtk, Gdk } = imports.gi;
const display = Gdk.Display.get_default();

const Draggable = ({ maxOffset = 150, startMargin = 0, style, connections = [], ...props }) => {
  let w = EventBox({
    onHover: box => {
      box.window.set_cursor(Gdk.Cursor.new_from_name(display, 'grab'));
    },
    onHoverLost: box => {
      box.window.set_cursor(null);
    },
  });

  let gesture = Gtk.GestureDrag.new(w);

  w.child = Box({
    ...props,
    connections: [

      [gesture, box => {
        const offset = gesture.get_offset()[1];

        box.setStyle('margin-left: ' + Number(offset + startMargin) + 'px; ' + style);
        w.window.set_cursor(Gdk.Cursor.new_from_name(display, 'grabbing'));
      }, 'drag-update'],

      [gesture, box => {
        const offset = gesture.get_offset()[1];

        if (offset > maxOffset || offset < -maxOffset) {
          w.destroy();
        }
        else {
          box.setStyle('transition: margin-left 0.5s ease; margin-left: ' + startMargin + 'px; ' + style);
          w.window.set_cursor(Gdk.Cursor.new_from_name(display, 'grab'));
        }
      }, 'drag-end'],

      ...connections,
    ],
  });

  return w;
};

export const DragTest = Window({
  name: 'drag-test',
  layer: 'overlay',
  anchor: 'top right',
  child: Box({
    style: 'background: white; min-width: 200px; min-height: 200px;',
    children: [
      Draggable({
        maxOffset: 120,
        startMargin: 5,
        className: 'test',
        style: 'background: black; min-width: 40px; min-height: 20px',
        child: Button({
          style: 'background: red; min-width: 10px; min-height: 10px',
          onClicked: 'echo hi',
        }),
      }),
    ],
  }),
});

const { Window, Box, EventBox } = ags.Widget;
const { Gtk, Gdk } = imports.gi;
const display = Gdk.Display.get_default();

var Gesture;
var shouldDelete = false;

const DraggableCtor = props => EventBox({
  onHover: box => {
    box.window.set_cursor(Gdk.Cursor.new_from_name(display, 'grab'));
  },
  onHoverLost: box => {
    box.window.set_cursor(null);
  },
  setup: widget => {
    Gesture = Gtk.GestureDrag.new(widget);
  },
  child: Box({
    style: 'background: black; min-width: 40px; min-height: 20px',
  }),
  ...props,
});

const Draggable = DraggableCtor();

export const DragTest = Window({
  name: 'drag-test',
  layer: 'overlay',
  anchor: 'top right',
  child: Box({
    style: 'background: white; min-width: 200px; min-height: 200px;',
    children: [
      Draggable,
      Box({
        connections: [
          [Gesture, event => {
            const offset = Gesture.get_offset()[1];
            Draggable.child.setStyle('background: black; min-width: 40px; min-height: 20px; margin-left: ' + offset + 'px;');
            Draggable.window.set_cursor(Gdk.Cursor.new_from_name(display, 'grabbing'));

            if (offset > 150) {
              shouldDelete = true;
            }
            else if (shouldDelete) {
              shouldDelete = false;
            }
          }, 'drag-update'],

          [Gesture, event => {
            if (shouldDelete) {
              Draggable.destroy();
            }
            else {
              Draggable.child.setStyle('transition: margin 0.5s ease; background: black; min-width: 40px; min-height: 20px');
              Draggable.window.set_cursor(Gdk.Cursor.new_from_name(display, 'grab'));
            }
            print('end');
          }, 'drag-end'],
        ],
      }),
    ],
  }),
});

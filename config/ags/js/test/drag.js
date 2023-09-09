const { Window, Box, EventBox } = ags.Widget;
const { Gtk, Gdk } = imports.gi;

var Gesture;
var shouldDelete = false;

const DraggableCtor = props => EventBox({
  setup: widget => {
    Gesture = Gtk.GestureDrag.new(widget);
  },
  child: Box({
    style: 'background: black; min-width: 20px; min-height: 20px',
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
            Draggable.child.setStyle('background: black; min-width: 20px; min-height: 20px; margin-left: ' + Gesture.get_offset()[1] + 'px;')
          }, 'drag-update'],

          [Gesture, event => {
            Draggable.child.setStyle('transition: margin 0.5s ease; background: black; min-width: 20px; min-height: 20px')
          }, 'drag-end'],
        ],
      }),
    ],
  }),
});

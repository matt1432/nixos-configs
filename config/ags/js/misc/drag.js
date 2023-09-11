const { Window, Box, EventBox, Button } = ags.Widget;
const { Gtk, Gdk } = imports.gi;
const display = Gdk.Display.get_default();

// TODO: add slide away anim
export const Draggable = ({
  maxOffset = 150,
  startMargin = 0,
  command = () => {},
  addOnHover = w => {},
  addOnHoverLost = w => {},
  child = '',
  children = [],
  ...params
}) => {
  let w = EventBox({
    ...params,
    onHover: box => {
      box.window.set_cursor(Gdk.Cursor.new_from_name(display, 'grab'));
      addOnHover(box);
    },
    onHoverLost: box => {
      box.window.set_cursor(null);
      addOnHoverLost(box);
    },
  });

  let gesture = Gtk.GestureDrag.new(w);

  w.child = Box({
    children: [
      ...children,
      child,
    ],
    connections: [

      [gesture, box => {
        var offset = gesture.get_offset()[1];

        if (offset >= 0) {
          box.setStyle('margin-left: ' + Number(offset + startMargin) + 'px; ' + 
                       'margin-right: -' + Number(offset + startMargin) + 'px;');
        }
        else {
          offset = Math.abs(offset);
          box.setStyle('margin-right: ' + Number(offset + startMargin) + 'px; ' + 
                       'margin-left: -' + Number(offset + startMargin) + 'px;');
        }
        
        if (w.window)
          w.window.set_cursor(Gdk.Cursor.new_from_name(display, 'grabbing'));
      }, 'drag-update'],

      [gesture, box => {
        const offset = gesture.get_offset()[1];

        if (Math.abs(offset) > maxOffset) {
          command();
        }
        else {
          box.setStyle('transition: margin 0.5s ease; margin-left: ' + startMargin + 'px; ' +
                                                     'margin-right: ' + startMargin + 'px;');
          if (w.window)
            w.window.set_cursor(Gdk.Cursor.new_from_name(display, 'grab'));
        }
      }, 'drag-end'],
    ],
  });

  return w;
};

/*export const DragTest = Window({
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
});*/

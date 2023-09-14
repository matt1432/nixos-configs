const { Window, Box, EventBox, Button } = ags.Widget;
const { Gtk, Gdk } = imports.gi;
const display = Gdk.Display.get_default();

export const Draggable = ({
  maxOffset = 150,
  startMargin = 0,
  endMargin = 300,
  command = () => {},
  onHover = w => {},
  onHoverLost = w => {},
  child = '',
  children = [],
  ...params
}) => {
  let w = EventBox({
    ...params,
    onHover: box => {
      box.window.set_cursor(Gdk.Cursor.new_from_name(display, 'grab'));
      onHover(box);
    },
    onHoverLost: box => {
      box.window.set_cursor(null);
      onHoverLost(box);
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
          if (offset > 0) {
            box.setStyle('transition: margin 0.5s ease, opacity 0.5s ease; ' + 
                         'margin-left: ' + Number(maxOffset + endMargin) + 'px; ' +
                         'margin-right: -' + Number(maxOffset + endMargin) + 'px; ' +
                         'margin-bottom: -70px; margin-top: -70px; opacity: 0;');
          }
          else {
            box.setStyle('transition: margin 0.5s ease, opacity 0.5s ease; ' + 
                         'margin-left: -' + Number(maxOffset + endMargin) + 'px; ' +
                         'margin-right: ' + Number(maxOffset + endMargin) + 'px; ' +
                         'margin-bottom: -70px; margin-top: -70px; opacity: 0;');
          }
          setTimeout(command, 500);
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

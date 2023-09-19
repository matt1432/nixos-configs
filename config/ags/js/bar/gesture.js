const { Window, CenterBox, EventBox, Button } = ags.Widget;
const { openWindow } = ags.App;
const { Gtk, Gdk } = imports.gi;
const display = Gdk.Display.get_default();

export const Gesture = ({
  child,
  ...params
}) => {
  let w = EventBox({
    ...params,
  });

  let gesture = Gtk.GestureSwipe.new(w);

  w.child = CenterBox({
    children: [
      child,
    ],
    connections: [

      [gesture, box => {
        const velocity = gesture.get_velocity()[1];
        if (velocity < -100)
          openWindow('quick-settings');
      }, 'update'],

    ],
  });

  return w;
};

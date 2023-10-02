import { Widget, App } from '../../imports.js';
const { CenterBox, EventBox } = Widget;
const { openWindow } = App;

import Gtk from 'gi://Gtk';


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

      [gesture, _ => {
        const velocity = gesture.get_velocity()[1];
        if (velocity < -100)
          openWindow('quick-settings');
      }, 'update'],

    ],
  });

  return w;
};

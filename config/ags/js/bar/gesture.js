import { Widget, App } from '../../imports.js';
const { CenterBox, EventBox } = Widget;

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
          App.openWindow('quick-settings');
      }, 'update'],

    ],
  });

  return w;
};

import { Widget, App } from '../../imports.js';
const { CenterBox, EventBox } = Widget;

import Gtk from 'gi://Gtk';


export default ({
  child,
  ...props
}) => {
  let widget = EventBox({
    ...props,
  });

  let gesture = Gtk.GestureSwipe.new(widget);

  widget.add(CenterBox({
    children: [ child ],
    connections: [[gesture, () => {
      const velocity = gesture.get_velocity()[1];
      if (velocity < -100)
        App.openWindow('quick-settings');

    }, 'update']],
  }));

  return widget;
};

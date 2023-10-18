import { Mpris, Widget } from '../../imports.js';
const { Icon } = Widget;

import Gtk from 'gi://Gtk';
import EventBox    from '../misc/cursorbox.js';

export default () => {
  let widget = EventBox({});

  let toggleButton = Gtk.ToggleButton.new();
  toggleButton.add(Icon({
    icon: 'go-down-symbolic',
    className: 'arrow',
    style: `-gtk-icon-transform: rotate(180deg);`,
  }));

  // Setup
  const id = Mpris.connect('changed', () => {
    toggleButton.set_active(Mpris.players.length > 0);
    Mpris.disconnect(id);
  });

  // Connections
  toggleButton.connect('toggled', () => {
    let rev = toggleButton.get_parent().get_parent().get_parent().children[1];

    if (toggleButton.get_active()) {
      toggleButton.get_children()[0]
        .setStyle("-gtk-icon-transform: rotate(0deg);");
      rev.revealChild = true;
    }
    else {
      toggleButton.get_children()[0]
        .setStyle('-gtk-icon-transform: rotate(180deg);');
      rev.revealChild = false;
    }
  });

  widget.add(toggleButton);

  return widget;
}

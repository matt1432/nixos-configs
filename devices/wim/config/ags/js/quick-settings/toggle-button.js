import Mpris from 'resource:///com/github/Aylur/ags/service/mpris.js';
import { Icon } from 'resource:///com/github/Aylur/ags/widget.js';

import Gtk from 'gi://Gtk';
import EventBox from '../misc/cursorbox.js';

export default () => {
    const widget = EventBox({});

    const toggleButton = Gtk.ToggleButton.new();
    toggleButton.add(Icon({
        icon: 'go-down-symbolic',
        className: 'arrow',
        css: '-gtk-icon-transform: rotate(180deg);',
    }));

    // Setup
    const id = Mpris.connect('changed', () => {
        toggleButton.set_active(Mpris.players.length > 0);
        Mpris.disconnect(id);
    });

    // Connections
    toggleButton.connect('toggled', () => {
        const rev = toggleButton.get_parent().get_parent().get_parent().children[1];

        if (toggleButton.get_active()) {
            toggleButton.get_children()[0]
                .setCss('-gtk-icon-transform: rotate(0deg);');
            rev.revealChild = true;
        }
        else {
            toggleButton.get_children()[0]
                .setCss('-gtk-icon-transform: rotate(180deg);');
            rev.revealChild = false;
        }
    });

    widget.add(toggleButton);

    return widget;
};

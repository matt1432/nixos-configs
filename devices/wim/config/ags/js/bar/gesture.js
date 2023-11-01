import App from 'resource:///com/github/Aylur/ags/app.js';
import { CenterBox, EventBox } from 'resource:///com/github/Aylur/ags/widget.js';

import Gtk from 'gi://Gtk';


export default ({
    child,
    ...props
}) => {
    const widget = EventBox({
        ...props,
    });

    const gesture = Gtk.GestureSwipe.new(widget);

    widget.add(CenterBox({
        children: [child],
        connections: [[gesture, () => {
            const velocity = gesture.get_velocity()[1];
            if (velocity < -100)
                App.openWindow('applauncher');
        }, 'update']],
    }));

    return widget;
};

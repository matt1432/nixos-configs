import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { lookUpIcon } from 'resource:///com/github/Aylur/ags/utils.js';

import Separator from '../misc/separator.js';


export default app => {
    const title = Widget.Label({
        class_name: 'title',
        label: app.name,
        xalign: 0,
        vpack: 'center',
        truncate: 'end',
    });

    const description = Widget.Label({
        class_name: 'description',
        label: app.description || '',
        wrap: true,
        xalign: 0,
        justification: 'left',
        vpack: 'center',
    });

    const icon = Widget.Icon({
        icon: lookUpIcon(app.icon_name) ? app.icon_name :
            app.app.get_string('Icon') !== 'nix-snowflake' ? app.app.get_string('Icon') : '',
        size: 42,
    });

    const textBox = Widget.Box({
        vertical: true,
        vpack: 'center',
        children: [title, description],
    });

    return Widget.Button({
        class_name: 'app',
        setup: self => self.app = app,
        on_clicked: () => {
            App.closeWindow('applauncher');
            Hyprland.sendMessage(`dispatch exec sh -c ${app.executable}`);
            ++app.frequency;
        },
        child: Widget.Box({
            children: [icon, Separator(16), textBox],
        }),
    });
};

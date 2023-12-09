import App from 'resource:///com/github/Aylur/ags/app.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

import { Box, Icon, Label } from 'resource:///com/github/Aylur/ags/widget.js';
import { lookUpIcon } from 'resource:///com/github/Aylur/ags/utils.js';

import EventBox from '../misc/cursorbox.js';


export default (app) => {
    const icon = Icon({
        icon: lookUpIcon(app.icon_name) ?
            app.icon_name :
            app.app.get_string('Icon') === 'nix-snowflake' ?
                '' :
                app.app.get_string('Icon'),
        size: 42,
    });

    const textBox = Box({
        vertical: true,
        vpack: 'start',

        children: [
            Label({
                class_name: 'title',
                label: app.name,
                xalign: 0,
                truncate: 'end',
            }),

            Label({
                class_name: 'description',
                label: app.description || '',
                wrap: true,
                xalign: 0,
                justification: 'left',
            }),

            Label(),
        ],
    });


    return EventBox({
        hexpand: true,
        class_name: 'app',

        setup: (self) => {
            self.app = app;
        },

        onPrimaryClickRelease: () => {
            App.closeWindow('applauncher');
            Hyprland.sendMessage(`dispatch exec sh -c ${app.executable}`);
            ++app.frequency;
        },

        child: Box({
            children: [
                icon,
                textBox,
            ],
        }),
    });
};

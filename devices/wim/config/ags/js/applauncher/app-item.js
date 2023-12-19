import App from 'resource:///com/github/Aylur/ags/app.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

import { Box, Icon, Label } from 'resource:///com/github/Aylur/ags/widget.js';
import { lookUpIcon } from 'resource:///com/github/Aylur/ags/utils.js';

import CursorBox from '../misc/cursorbox.js';


/**
 * @param {import('types/service/applications.js').Application} app
 */
export default (app) => {
    const icon = Icon({ size: 42 });
    const iconString = app.app.get_string('Icon');

    if (app.icon_name) {
        if (lookUpIcon(app.icon_name)) {
            icon.icon = app.icon_name;
        }
        else if (iconString && iconString !== 'nix-snowflake') {
            icon.icon = iconString;
        }
        else {
            icon.icon = '';
        }
    }

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

    return CursorBox({
        hexpand: true,
        class_name: 'app',

        attribute: { app },

        on_primary_click_release: (self) => {
            App.closeWindow('applauncher');
            Hyprland.sendMessage(`dispatch exec sh -c
                ${self.attribute.app.executable}`);
            ++self.attribute.app.frequency;
        },

        child: Box({
            children: [
                icon,
                textBox,
            ],
        }),
    });
};

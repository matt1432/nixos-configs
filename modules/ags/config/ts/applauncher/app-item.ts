const { Box, Icon, Label } = Widget;
const { lookUpIcon } = Utils;

import CursorBox from '../misc/cursorbox.ts';

/* Types */
import { Application } from 'types/service/applications.ts';


export default (app: Application) => {
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

        child: Box({
            children: [
                icon,
                textBox,
            ],
        }),
    });
};

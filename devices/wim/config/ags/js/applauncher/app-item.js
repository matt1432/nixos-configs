import App from 'resource:///com/github/Aylur/ags/app.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

import { Box, Button, CenterBox, Icon, Label } from 'resource:///com/github/Aylur/ags/widget.js';
import { lookUpIcon } from 'resource:///com/github/Aylur/ags/utils.js';

import Separator from '../misc/separator.js';

const ENTRY_SPACING = 16;

export default (app) => {
    const title = Label({
        class_name: 'title',
        label: app.name,
        xalign: 0,
        vpack: 'center',
        truncate: 'end',
    });

    const description = Label({
        class_name: 'description',
        label: app.description || '',
        wrap: true,
        xalign: 0,
        justification: 'left',
        vpack: 'center',
    });

    const icon = Icon({
        icon: lookUpIcon(app.icon_name) ?
            app.icon_name :
            app.app.get_string('Icon') === 'nix-snowflake' ?
                '' :
                app.app.get_string('Icon'),
        size: 42,
    });

    const textBox = CenterBox({
        vertical: true,
        start_widget: title,
        center_widget: description,
        end_widget: Separator(ENTRY_SPACING, { vertical: true }),
    });


    return Button({
        class_name: 'app',

        setup: (self) => {
            self.app = app;
        },

        on_clicked: () => {
            App.closeWindow('applauncher');
            Hyprland.sendMessage(`dispatch exec sh -c ${app.executable}`);
            ++app.frequency;
        },

        child: Box({
            children: [
                icon,
                Separator(ENTRY_SPACING),
                textBox,
            ],
        }),
    });
};

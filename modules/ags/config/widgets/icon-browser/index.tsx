import { Gdk, Gtk } from 'ags/gtk4';

import SortedList from '../misc/sorted-list';

export default () =>
    SortedList<string>({
        name: 'icon-browser',

        create_list: () =>
            Gtk.IconTheme.get_for_display(Gdk.Display.get_default()!)
                .get_icon_names()
                .filter((icon) => icon.endsWith('symbolic'))
                .sort(),

        create_row: (icon) =>
            (
                <box>
                    <image
                        iconName={icon}
                        pixelSize={60}
                        css="margin-right: 25px;"
                    />
                    <label label={icon} />
                </box>
            ) as Gtk.Box,

        on_activate: (icon) => {
            console.log(icon);
        },

        compare: (a, b) => a.charCodeAt(0) - b.charCodeAt(0),
    });

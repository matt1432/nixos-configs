import { Gtk, Widget } from 'astal/gtk3';

import SortedList from '../misc/sorted-list';


export default () => SortedList({
    name: 'icon-browser',

    create_list: () => Gtk.IconTheme.get_default().list_icons(null)
        .filter((icon) => icon.endsWith('symbolic'))
        .sort(),

    create_row: (icon) => (
        <box>
            <icon css="font-size: 60px; margin-right: 25px;" icon={icon} />
            <label label={icon} />
        </box>
    ),

    on_row_activated: (row) => {
        const icon = ((row.get_children()[0] as Widget.Box).get_children()[0] as Widget.Icon).icon;

        console.log(icon);
    },

    sort_func: (a, b, entry, fzfResults) => {
        const row1 = ((a.get_children()[0] as Widget.Box).get_children()[0] as Widget.Icon).icon;
        const row2 = ((b.get_children()[0] as Widget.Box).get_children()[0] as Widget.Icon).icon;

        if (entry.text === '' || entry.text === '-') {
            a.set_visible(true);
            b.set_visible(true);

            return row1.charCodeAt(0) - row2.charCodeAt(0);
        }
        else {
            const s1 = fzfResults.find((r) => r.item === row1)?.score ?? 0;
            const s2 = fzfResults.find((r) => r.item === row2)?.score ?? 0;

            a.set_visible(s1 !== 0);
            b.set_visible(s2 !== 0);

            return s2 - s1;
        }
    },
});

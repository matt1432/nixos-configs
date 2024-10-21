import { Astal, Gtk, Widget } from 'astal/gtk3';
import { idle } from 'astal';

import { Fzf, FzfResultItem } from 'fzf';

import PopupWindow from '../misc/popup-window';
import { centerCursor } from '../../lib';


export default () => {
    let Icons: string[] = [];
    let fzfResults = [] as FzfResultItem<string>[];

    const list = new Gtk.ListBox({
        selectionMode: Gtk.SelectionMode.SINGLE,
    });

    list.connect('row-activated', (_, row) => {
        const icon = ((row.get_children()[0] as Widget.Box).get_children()[0] as Widget.Icon).icon;

        console.log(icon);
    });

    const placeholder = (
        <revealer>
            <label
                label="   Couldn't find a match"
                className="placeholder"
            />
        </revealer>
    ) as Widget.Revealer;

    const on_text_change = (text: string) => {
        const fzf = new Fzf(Icons);

        fzfResults = fzf.find(text);
        list.invalidate_sort();

        const visibleIcons = list.get_children().filter((row) => row.visible).length;

        placeholder.reveal_child = visibleIcons <= 0;
    };

    const entry = (
        <entry
            onChanged={(self) => on_text_change(self.text)}
            hexpand
        />
    ) as Widget.Entry;

    list.set_sort_func((a, b) => {
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
    });

    const refreshIcons = () => idle(() => {
        (list.get_children() as Gtk.ListBoxRow[])
            .forEach((child) => {
                child.destroy();
            });

        Icons = Gtk.IconTheme.get_default().list_icons(null)
            .filter((icon) => icon.endsWith('symbolic'))
            .sort();

        Icons
            .flatMap((icon) => (
                <box>
                    <icon css="font-size: 60px; margin-right: 25px;" icon={icon} />
                    <label label={icon} />
                </box>
            ))
            .forEach((child) => {
                list.add(child);
            });

        list.show_all();
        on_text_change('');
    });

    refreshIcons();

    return (
        <PopupWindow
            name="icon-browser"
            keymode={Astal.Keymode.ON_DEMAND}
            on_open={() => {
                entry.text = '';
                centerCursor();
            }}
        >
            <box
                vertical
                className="icon-browser"
            >
                <box className="widget icon-search">

                    <icon icon="preferences-system-search-symbolic" />

                    {entry}

                    <button
                        css="margin-left: 5px;"
                        onButtonReleaseEvent={refreshIcons}
                    >
                        <icon icon="view-refresh-symbolic" css="font-size: 26px;" />
                    </button>

                </box>

                <scrollable
                    className="widget icon-list"

                    css="min-height: 600px; min-width: 600px;"
                    hscroll={Gtk.PolicyType.NEVER}
                    vscroll={Gtk.PolicyType.AUTOMATIC}
                >
                    <box vertical>
                        {list}
                        {placeholder}
                    </box>
                </scrollable>
            </box>
        </PopupWindow>
    );
};

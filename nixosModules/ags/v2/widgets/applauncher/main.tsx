import { App, Astal, Gtk, Widget } from 'astal/gtk3';
import { idle } from 'astal';

import AstalApps from 'gi://AstalApps';

import { Fzf, FzfResultItem } from 'fzf';

import PopupWindow from '../misc/popup-window';
import { centerCursor } from '../../lib';

import AppItemWidget, { AppItem } from './app-item';
import { launchApp } from './launch';


export default () => {
    let Applications: AstalApps.Application[] = [];
    let fzfResults = [] as FzfResultItem<AstalApps.Application>[];

    const list = new Gtk.ListBox({
        selectionMode: Gtk.SelectionMode.SINGLE,
    });

    list.connect('row-activated', (_, row) => {
        const app = (row.get_children()[0] as AppItem).app;

        launchApp(app);
        App.get_window('win-applauncher')?.set_visible(false);
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
        const fzf = new Fzf(Applications, {
            selector: (app) => app.name + app.executable,

            tiebreakers: [
                (a, b) => b.item.frequency - a.item.frequency,
            ],
        });

        fzfResults = fzf.find(text);
        list.invalidate_sort();

        const visibleApplications = list.get_children().filter((row) => row.visible).length;

        placeholder.reveal_child = visibleApplications <= 0;
    };

    const entry = (
        <entry
            onChanged={(self) => on_text_change(self.text)}
            hexpand
        />
    ) as Widget.Entry;

    list.set_sort_func((a, b) => {
        const row1 = (a.get_children()[0] as AppItem).app;
        const row2 = (b.get_children()[0] as AppItem).app;

        if (entry.text === '' || entry.text === '-') {
            a.set_visible(true);
            b.set_visible(true);

            return row2.frequency - row1.frequency;
        }
        else {
            const s1 = fzfResults.find((r) => r.item.name === row1.name)?.score ?? 0;
            const s2 = fzfResults.find((r) => r.item.name === row2.name)?.score ?? 0;

            a.set_visible(s1 !== 0);
            b.set_visible(s2 !== 0);

            return s2 - s1;
        }
    });

    const refreshApplications = () => idle(() => {
        (list.get_children() as Gtk.ListBoxRow[])
            .forEach((child) => {
                child.destroy();
            });

        Applications = AstalApps.Apps.new().get_list();

        Applications
            .flatMap((app) => AppItemWidget({ app }))
            .forEach((child) => {
                list.add(child);
            });

        list.show_all();
        on_text_change('');
    });

    refreshApplications();

    return (
        <PopupWindow
            name="applauncher"
            keymode={Astal.Keymode.ON_DEMAND}
            on_open={() => {
                entry.text = '';
                centerCursor();
            }}
        >
            <box
                vertical
                className="applauncher"
            >
                <box className="widget app-search">

                    <icon icon="preferences-system-search-symbolic" />

                    {entry}

                    <button
                        css="margin-left: 5px;"
                        cursor="pointer"
                        onButtonReleaseEvent={refreshApplications}
                    >
                        <icon icon="view-refresh-symbolic" css="font-size: 26px;" />
                    </button>

                </box>

                <eventbox cursor="pointer">
                    <scrollable
                        className="widget app-list"

                        css="min-height: 600px; min-width: 600px;"
                        hscroll={Gtk.PolicyType.NEVER}
                        vscroll={Gtk.PolicyType.AUTOMATIC}
                    >
                        <box vertical>
                            {list}
                            {placeholder}
                        </box>
                    </scrollable>
                </eventbox>
            </box>
        </PopupWindow>
    );
};

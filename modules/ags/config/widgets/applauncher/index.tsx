import { App } from 'astal/gtk3';

import AstalApps from 'gi://AstalApps';

import SortedList from '../misc/sorted-list';

import { launchApp } from './launch';
import AppItem from './app-item';


export default () => SortedList({
    name: 'applauncher',

    create_list: () => AstalApps.Apps.new().get_list(),

    create_row: (app) => <AppItem app={app} />,

    fzf_options: {
        selector: (app) => app.name + app.executable,

        tiebreakers: [
            (a, b) => b.item.frequency - a.item.frequency,
        ],
    },

    unique_props: ['name', 'executable'],

    on_row_activated: (row) => {
        const app = (row.get_children()[0] as AppItem).app;

        launchApp(app);
        App.get_window('win-applauncher')?.set_visible(false);
    },

    sort_func: (a, b, entry, fzfResults) => {
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
    },
});

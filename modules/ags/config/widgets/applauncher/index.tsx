import AstalApps from 'gi://AstalApps';

import { getWindow } from '../../lib';
import SortedList from '../misc/sorted-list';
import AppItem from './app-item';
import { launchApp } from './launch';

export default () => {
    return SortedList({
        name: 'applauncher',

        create_list: () => AstalApps.Apps.new().get_list(),

        create_row: (app) => (<AppItem app={app} class="app" />) as AppItem,

        fzf_options: {
            selector: (app) => app.get_name() + app.get_executable(),

            tiebreakers: [
                (a, b) => b.item.get_frequency() - a.item.get_frequency(),
            ],
        },

        unique_props: ['name', 'executable'],

        on_row_activated: (row) => {
            const app = (row.get_children()[0] as AppItem).app;

            launchApp(app);
            getWindow('win-applauncher')?.set_visible(false);
        },

        sort_func: (a, b, entry, fzfResults) => {
            const row1 = (a.get_children()[0] as AppItem).app;
            const row2 = (b.get_children()[0] as AppItem).app;

            if (entry.text === '' || entry.text === '-') {
                a.set_visible(true);
                b.set_visible(true);

                return row2.get_frequency() - row1.get_frequency();
            }
            else {
                const s1 =
                    fzfResults.find(
                        (r) => r.item.get_name() === row1.get_name(),
                    )?.score ?? 0;
                const s2 =
                    fzfResults.find(
                        (r) => r.item.get_name() === row2.get_name(),
                    )?.score ?? 0;

                a.set_visible(s1 !== 0);
                b.set_visible(s2 !== 0);

                return s2 - s1;
            }
        },
    });
};

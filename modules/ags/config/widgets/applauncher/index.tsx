import { Gtk } from 'ags/gtk4';
import AstalApps from 'gi://AstalApps';

import { getWindow } from '../../lib';
import SortedList from '../misc/sorted-list';
import AppItem from './app-item';
import { launchApp } from './launch';

export default () =>
    SortedList<AstalApps.Application>({
        name: 'applauncher',

        create_list: () => AstalApps.Apps.new().get_list(),

        create_row: (app) => (<AppItem app={app} />) as Gtk.Widget,

        fzf_options: {
            selector: (app) => app.get_name() + app.get_executable(),

            tiebreakers: [
                (a, b) => b.item.get_frequency() - a.item.get_frequency(),
            ],
        },

        unique_props: ['name', 'executable'],

        on_activate: (app) => {
            launchApp(app);
            getWindow('win-applauncher')?.set_visible(false);
        },

        compare: (a, b) => b.get_frequency() - a.get_frequency(),
    });

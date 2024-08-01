const Applications = await Service.import('applications');

import { Fzf, FzfResultItem } from 'fzf';

import SortedList from '../misc/sorted-list.ts';
import AppItem from './app-item.ts';

import { launchApp } from './launch.ts';

/* Types */
import { Application } from 'types/service/applications.ts';
import { AgsAppItem } from 'global-types';


export default () => {
    let fzfResults = [] as FzfResultItem<Application>[];

    return SortedList({
        name: 'applauncher',
        class_name: 'applauncher',
        transition: 'slide top',

        on_select: (r) => {
            App.closeWindow('win-applauncher');
            launchApp((r.get_child() as AgsAppItem).attribute.app);
        },

        setup_list: (list, entry) => {
            Applications.query('')
                .flatMap((app) => AppItem(app))
                .forEach((ch) => {
                    list.add(ch);
                });

            list.show_all();

            list.set_sort_func((a, b) => {
                const row1 = (a.get_children()[0] as AgsAppItem).attribute.app;
                const row2 = (b.get_children()[0] as AgsAppItem).attribute.app;

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
        },

        on_text_change: (text, list, placeholder) => {
            const fzf = new Fzf(Applications.list, {
                selector: (app) => app.name + app.executable,

                tiebreakers: [
                    (a, b) => b.item.frequency - a.item.frequency,
                ],
            });

            fzfResults = fzf.find(text);
            list.invalidate_sort();

            const visibleApps = list.get_children().filter((row) => row.visible).length;

            placeholder.reveal_child = visibleApps <= 0;
        },
    });
};

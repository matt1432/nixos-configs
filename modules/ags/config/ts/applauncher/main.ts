const Applications = await Service.import('applications');

import { Fzf, FzfResultItem } from 'fzf';

import SortedList from '../misc/sorted-list.ts';
import AppItem from './app-item.ts';

import { launchApp } from './launch.ts';

/* Types */
import { ListBoxRow } from 'types/@girs/gtk-3.0/gtk-3.0.cjs';
import { Application } from 'types/service/applications.ts';
import { AgsAppItem } from 'global-types';


export default () => {
    let fzfResults: FzfResultItem<Application>[];

    return SortedList({
        name: 'applauncher',
        class_name: 'applauncher',
        transition: 'slide top',

        on_select: (r) => {
            App.closeWindow('win-applauncher');
            launchApp((r.get_child() as AgsAppItem).attribute.app);
        },

        init_rows: (list) => {
            const rows = list.get_children() as ListBoxRow[];

            rows.forEach((ch) => {
                ch.destroy();
            });

            const children = Applications.query('')
                .flatMap((app) => AppItem(app));

            children.forEach((ch) => {
                list.add(ch);
            });
            list.show_all();
        },

        set_sort: (text, list, placeholder) => {
            const fzf = new Fzf(Applications.list, {
                selector: (app) => app.name + app.executable,

                tiebreakers: [
                    (a, b) => b.item.frequency - a.item.frequency,
                ],
            });

            fzfResults = fzf.find(text);
            list.set_sort_func((a, b) => {
                const row1 = (a.get_children()[0] as AgsAppItem).attribute.app.name;
                const row2 = (b.get_children()[0] as AgsAppItem).attribute.app.name;

                const s1 = fzfResults.find((r) => r.item.name === row1)?.score ?? 0;
                const s2 = fzfResults.find((r) => r.item.name === row2)?.score ?? 0;

                return s2 - s1;
            });

            let visibleApps = 0;

            const rows = list.get_children() as ListBoxRow[];

            rows.forEach((row) => {
                row.changed();

                const item = row.get_children()[0] as AgsAppItem;

                if (item.attribute.app) {
                    const isMatching = fzfResults.some((r) => {
                        return r.item.name === item.attribute.app.name;
                    });

                    row.visible = isMatching;

                    if (isMatching) {
                        ++visibleApps;
                    }
                }
            });
            placeholder.reveal_child = visibleApps <= 0;
        },
    });
};

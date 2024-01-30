const Applications = await Service.import('applications');
const { Box, Entry, Icon, Label, ListBox, Revealer, Scrollable } = Widget;

// @ts-expect-error find cleaner way to import this
import { Fzf, FzfResultItem } from 'file:///home/matt/.nix/modules/ags/config/node_modules/fzf/dist/fzf.es.js';

import PopupWindow from '../misc/popup.ts';
import AppItem from './app-item.ts';

// Types
import { ListBoxRow } from 'types/@girs/gtk-3.0/gtk-3.0.cjs';
import { Application } from 'types/service/applications.ts';
import { AgsAppItem } from 'global-types';


const Applauncher = (window_name = 'applauncher') => {
    let fzfResults: FzfResultItem<Application>[];
    const list = ListBox();

    const setSort = (text: string) => {
        const fzf = new Fzf(Applications.list, {
            selector: (app: Application) => {
                return app.name + app.executable;
            },
            tiebreakers: [
                (a: Application, b: Application) => b.frequency - a.frequency,
            ],
        });

        fzfResults = fzf.find(text);
        list.set_sort_func((a, b) => {
            const row1 = (a.get_children()[0] as AgsAppItem).attribute.app.name;
            const row2 = (b.get_children()[0] as AgsAppItem).attribute.app.name;

            if (!row1 || !row2) {
                return 0;
            }

            return fzfResults.indexOf(row1) -
            fzfResults.indexOf(row1) || 0;
        });
    };

    const makeNewChildren = () => {
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
    };

    makeNewChildren();

    const placeholder = Revealer({
        child: Label({
            label: "   Couldn't find a match",
            class_name: 'placeholder',
        }),
    });

    const entry = Entry({
        // Set some text so on-change works the first time
        text: '-',
        hexpand: true,

        on_accept: ({ text }) => {
            const appList = Applications.query(text || '');

            if (appList[0]) {
                App.closeWindow(window_name);
                appList[0].launch();
            }
        },

        on_change: ({ text }) => {
            if (text === null) {
                return;
            }
            setSort(text);
            let visibleApps = 0;

            const rows = list.get_children() as ListBoxRow[];

            rows.forEach((row) => {
                row.changed();

                const item = (row.get_children()[0] as AgsAppItem);

                if (item.attribute.app) {
                    const isMatching = fzfResults.find((r) => {
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

    return Box({
        class_name: 'applauncher',
        vertical: true,

        setup: (self) => {
            self.hook(App, (_, name, visible) => {
                if (name !== window_name) {
                    return;
                }

                entry.text = '';

                if (visible) {
                    entry.grab_focus();
                }
                else {
                    makeNewChildren();
                }
            });
        },

        children: [
            Box({
                class_name: 'header',
                children: [
                    Icon('preferences-system-search-symbolic'),
                    entry,
                ],
            }),

            Scrollable({
                hscroll: 'never',
                vscroll: 'automatic',
                child: Box({
                    vertical: true,
                    children: [list, placeholder],
                }),
            }),
        ],
    });
};

export default () => PopupWindow({
    name: 'applauncher',
    keymode: 'on-demand',
    content: Applauncher(),
});

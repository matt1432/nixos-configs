import App from 'resource:///com/github/Aylur/ags/app.js';
import Applications from 'resource:///com/github/Aylur/ags/service/applications.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
// TODO: find cleaner way to import this
import { Fzf } from '../../node_modules/fzf/dist/fzf.es.js';

import { Box, Entry, Icon, Label, ListBox, Revealer, Scrollable } from 'resource:///com/github/Aylur/ags/widget.js';

import PopupWindow from '../misc/popup.js';
import AppItem from './app-item.js';


const Applauncher = ({ window_name = 'applauncher' } = {}) => {
    let fzfResults;
    const list = ListBox();

    /** @param {String} text */
    const setSort = (text) => {
        const fzf = new Fzf(Applications.list, {
            selector: (app) => app.name,
            tiebreakers: [(a, b) => b.frequency -
                a.frequency],
        });

        fzfResults = fzf.find(text);
        list.set_sort_func((a, b) => {
            // @ts-expect-error
            const row1 = a.get_children()[0]?.attribute.app.name;
            // @ts-expect-error
            const row2 = b.get_children()[0]?.attribute.app.name;

            if (!row1 || !row2) {
                return 0;
            }

            return fzfResults.indexOf(row1) -
            fzfResults.indexOf(row1) || 0;
        });
    };

    const makeNewChildren = () => {
        list.get_children().forEach((ch) => {
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
                Hyprland.sendMessage(`dispatch exec sh -c
                    ${appList[0].executable}`);
                ++appList[0].frequency;
            }
        },

        on_change: ({ text }) => {
            if (text === null) {
                return;
            }
            setSort(text);
            let visibleApps = 0;

            list.get_children().forEach((row) => {
                // @ts-expect-error
                row.changed();

                // @ts-expect-error
                const item = row.get_children()[0];

                if (item?.attribute.app) {
                    const isMatching = Array.from(fzfResults).find((r) => {
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
    focusable: true,
    child: Applauncher(),
});

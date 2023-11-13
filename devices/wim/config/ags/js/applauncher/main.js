import App          from 'resource:///com/github/Aylur/ags/app.js';
import Applications from 'resource:///com/github/Aylur/ags/service/applications.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

import { Box, Entry, Icon, Label, Scrollable } from 'resource:///com/github/Aylur/ags/widget.js';

import PopupWindow from '../misc/popup.js';
import Separator from '../misc/separator.js';
import AppItem from './app-item.js';


const Applauncher = ({ window_name = 'applauncher' } = {}) => {
    const children = () => [
        ...Applications.query('').flatMap(app => {
            const item = AppItem(app);
            return [
                Separator(4, {
                    binds: [['visible', item, 'visible']],
                }),
                item,
            ];
        }),
        Separator(4),
    ];

    const list = Box({
        vertical: true,
        children: children(),
    });

    const entry = Entry({
        hexpand: true,
        placeholder_text: 'Search',

        // set some text so on-change works the first time
        text: '-',
        on_accept: ({ text }) => {
            const list = Applications.query(text || '');
            if (list[0]) {
                App.toggleWindow(window_name);
                Hyprland.sendMessage(`dispatch exec sh -c ${list[0]}`);
                ++list[0].frequency;
            }
        },
        on_change: ({ text }) => {
            let visibleApps = 0;
            list.children.map(item => {
                if (item.app) {
                    item.visible = item.app.match(text);

                    if (item.app.match(text))
                        ++visibleApps;
                }
            });
            placeholder.visible = visibleApps <= 0;
        },
    });

    const placeholder = Label({
        label: "   Couldn't find a match",
        className: 'placeholder',
    });


    return Box({
        className: 'applauncher',
        vertical: true,
        children: [
            Box({
                className: 'header',
                children: [
                    Icon('preferences-system-search-symbolic'),
                    entry,
                ],
            }),

            Scrollable({
                hscroll: 'never',
                child: Box({
                    vertical: true,
                    children: [list, placeholder],
                }),
            }),
        ],
        connections: [[App, (_, name, visible) => {
            if (name !== window_name)
                return;

            entry.text = '';
            if (visible)
                entry.grab_focus();
            else
                list.children = children();
        }]],
    });
};

export default () => PopupWindow({
    name: 'applauncher',
    focusable: true,
    child: Applauncher(),
});

import App from 'resource:///com/github/Aylur/ags/app.js';
import Applications from 'resource:///com/github/Aylur/ags/service/applications.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

import { Box, Entry, Icon, Label, Scrollable } from 'resource:///com/github/Aylur/ags/widget.js';

import PopupWindow from '../misc/popup.js';
import Separator from '../misc/separator.js';
import AppItem from './app-item.js';


const Applauncher = ({ window_name = 'applauncher' } = {}) => {
    const ICON_SEPARATION = 4;

    const children = () => [
        ...Applications.query('').flatMap((app) => {
            const item = AppItem(app);

            return [
                Separator(ICON_SEPARATION, {
                    binds: [['visible', item, 'visible']],
                }),
                item,
            ];
        }),
        Separator(ICON_SEPARATION),
    ];

    const list = Box({
        vertical: true,
        children: children(),
    });

    const placeholder = Label({
        label: "   Couldn't find a match",
        className: 'placeholder',
    });

    const entry = Entry({
        // Set some text so on-change works the first time
        text: '-',
        hexpand: true,

        on_accept: ({ text }) => {
            const appList = Applications.query(text || '');

            if (appList[0]) {
                App.toggleWindow(window_name);
                Hyprland.sendMessage(`dispatch exec sh -c ${appList[0]}`);
                ++appList[0].frequency;
            }
        },

        on_change: ({ text }) => {
            let visibleApps = 0;

            list.children.forEach((item) => {
                if (item.app) {
                    item.visible = item.app.match(text);

                    if (item.app.match(text)) {
                        ++visibleApps;
                    }
                }
            });
            placeholder.visible = visibleApps <= 0;
        },
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
            if (name !== window_name) {
                return;
            }

            entry.text = '';

            if (visible) {
                entry.grab_focus();
            }
            else {
                list.children = children();
            }
        }]],
    });
};

export default () => PopupWindow({
    name: 'applauncher',
    focusable: true,
    child: Applauncher(),
});

import SystemTray from 'resource:///com/github/Aylur/ags/service/systemtray.js';

import { timeout } from 'resource:///com/github/Aylur/ags/utils.js';
import { Box, Icon, MenuItem, MenuBar, Revealer } from 'resource:///com/github/Aylur/ags/widget.js';

import Separator from '../../misc/separator.js';

const REVEAL_DURATION = 500;
const SPACING = 12;


/** @param {import('types/service/systemtray').TrayItem} item */
const SysTrayItem = (item) => {
    if (item.id === 'spotify-client') {
        return;
    }

    return MenuItem({
        // @ts-expect-error
        submenu: item.menu,
        tooltip_markup: item.bind('tooltip_markup'),

        child: Revealer({
            transition: 'slide_right',
            transition_duration: REVEAL_DURATION,

            child: Icon({
                size: 24,
                // @ts-expect-error
                icon: item.bind('icon'),
            }),
        }),
    });
};

const SysTray = () => MenuBar({
    attribute: {
        items: new Map(),
    },

    setup: (self) => {
        self
            .hook(SystemTray, (_, id) => {
                const item = SystemTray.getItem(id);

                if (self.attribute.items.has(id) || !item) {
                    return;
                }

                const w = SysTrayItem(item);

                // Early return if item is in blocklist
                if (!w) {
                    return;
                }

                self.attribute.items.set(id, w);
                self.child = w;
                self.show_all();
                // @ts-expect-error
                w.child.reveal_child = true;
            }, 'added')

            .hook(SystemTray, (_, id) => {
                if (!self.attribute.items.has(id)) {
                    return;
                }

                self.attribute.items.get(id).child.reveal_child = false;
                timeout(REVEAL_DURATION, () => {
                    self.attribute.items.get(id).destroy();
                    self.attribute.items.delete(id);
                });
            }, 'removed');
    },
});

export default () => {
    const systray = SysTray();

    return Revealer({
        transition: 'slide_right',

        child: Box({
            children: [
                Box({
                    class_name: 'sys-tray',
                    children: [systray],
                }),

                Separator(SPACING),
            ],
        }),
    }).hook(SystemTray, (self) => {
        self.reveal_child = systray.get_children().length > 0;
    });
};

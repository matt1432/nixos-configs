import SystemTray from 'resource:///com/github/Aylur/ags/service/systemtray.js';

import { timeout } from 'resource:///com/github/Aylur/ags/utils.js';
import { Box, Icon, MenuItem, MenuBar, Revealer } from 'resource:///com/github/Aylur/ags/widget.js';

import Separator from '../../misc/separator.js';

const REVEAL_DURATION = 500;
const SPACING = 12;


const SysTrayItem = (item) => {
    if (item.id === 'spotify-client') {
        return;
    }

    return MenuItem({
        child: Revealer({
            transition: 'slide_right',
            transitionDuration: REVEAL_DURATION,

            child: Icon({
                size: 24,
                binds: [['icon', item, 'icon']],
            }),
        }),
        submenu: item.menu,
        binds: [['tooltipMarkup', item, 'tooltip-markup']],
    });
};

const SysTray = () => MenuBar({
    setup: (self) => {
        self.items = new Map();

        self.onAdded = (id) => {
            const item = SystemTray.getItem(id);

            if (self.items.has(id) || !item) {
                return;
            }

            const w = SysTrayItem(item);

            // Early return if item is in blocklist
            if (!w) {
                return;
            }

            self.items.set(id, w);
            self.add(w);
            self.show_all();
            w.child.revealChild = true;
        };

        self.onRemoved = (id) => {
            if (!self.items.has(id)) {
                return;
            }

            self.items.get(id).child.revealChild = false;
            timeout(REVEAL_DURATION, () => {
                self.items.get(id).destroy();
                self.items.delete(id);
            });
        };
    },
    connections: [
        [SystemTray, (self, id) => self.onAdded(id), 'added'],
        [SystemTray, (self, id) => self.onRemoved(id), 'removed'],
    ],
});

export default () => {
    const systray = SysTray();

    return Revealer({
        transition: 'slide_right',

        connections: [[SystemTray, (rev) => {
            rev.revealChild = systray.get_children().length > 0;
        }]],

        child: Box({
            children: [
                Box({
                    className: 'sys-tray',
                    children: [systray],
                }),

                Separator(SPACING),
            ],
        }),
    });
};

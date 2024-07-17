import AstalTray from 'gi://AstalTray?version=0.1';
const SystemTray = AstalTray.Tray.get_default();


const { timeout } = Utils;
const { Box, Icon, MenuItem, MenuBar, Revealer } = Widget;

import Separator from '../../misc/separator.ts';

const REVEAL_DURATION = 500;
const SPACING = 12;


const SysTrayItem = (item: AstalTray.TrayItem) => {
    if (item.id === 'spotify-client') {
        return;
    }

    return MenuItem({
        submenu: item.create_menu(),
        child: Revealer({
            transition: 'slide_right',
            transition_duration: REVEAL_DURATION,

            child: Icon({
                size: 24,
                icon: Utils.watch(
                    item.iconPixbuf || item.iconName || 'image-missing',
                    item,
                    () => item.iconPixbuf || item.iconName || 'image-missing',
                ),
            }),
        }),
    }).bind('tooltip_markup', item, 'tooltipMarkup');
};

const SysTray = () => MenuBar({
    attribute: { items: new Map() },

    setup: (self) => {
        self
            .hook(SystemTray, (_, id) => {
                if (!id) {
                    return;
                }

                const item = SystemTray.get_item(id);

                if (self.attribute.items.has(id) || !item) {
                    return;
                }

                const w = SysTrayItem(item);

                // Early return if item is in blocklist
                if (!w) {
                    return;
                }

                self.attribute.items.set(id, w);
                self.add(w);
                self.show_all();

                w.child.reveal_child = true;
            }, 'item_added')

            .hook(SystemTray, (_, id) => {
                if (!id || !self.attribute.items.has(id)) {
                    return;
                }

                self.attribute.items.get(id).child.reveal_child = false;
                timeout(REVEAL_DURATION, () => {
                    self.attribute.items.get(id).destroy();
                    self.attribute.items.delete(id);
                });
            }, 'item_removed');
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
    }, 'item_added');
};

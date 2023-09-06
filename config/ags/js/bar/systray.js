const { SystemTray } = ags.Service;
const { Box, Button, Icon, MenuItem } = ags.Widget;
const { Gtk } = imports.gi;

// this one uses a MenuBar and shouldn't throw that destroyed widget warning
const SysTrayItem = item => MenuItem({
    className: 'tray-item',
    child: Icon({
        size: 24,
    }),
    submenu: item.menu,
    connections: [[item, btn => {
        btn.child.icon = item.icon;
        btn.tooltipMarkup = item.tooltipMarkup;
    }]]
});

export const SysTrayModule = () => ags.Widget({
    type: Gtk.MenuBar,
    className: 'sys-tray',
    properties: [
        ['items', new Map()],
        ['onAdded', (box, id) => {
            const item = SystemTray.getItem(id);
            if (box._items.has(id) || !item)
                return;

            const widget = SysTrayItem(item);
            box._items.set(id, widget);
            box.add(widget);
            box.show_all();
        }],
        ['onRemoved', (box, id) => {
            if (!box._items.has(id))
                return;

            box._items.get(id).destroy();
            box._items.delete(id);
        }],
    ],
    connections: [
        [SystemTray, (box, id) => box._onAdded(box, id), 'added'],
        [SystemTray, (box, id) => box._onRemoved(box, id), 'removed'],
    ],
});

export const SysTray = SysTrayModule();

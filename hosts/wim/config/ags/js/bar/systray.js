import { SystemTray, Widget } from '../../imports.js';
const { Box, Revealer, Icon, MenuItem } = Widget;

import Gtk from 'gi://Gtk';

import { Separator } from '../misc/separator.js';


const SysTrayItem = item => MenuItem({
  className: 'tray-item',
  child: Revealer({
    transition: 'slide_right',
    child: Icon({
      size: 24,
    }),
  }),
  submenu: item.menu,
  connections: [[item, btn => {
    btn.child.child.icon = item.icon;
    btn.tooltipMarkup = item.tooltipMarkup;
  }]]
});

export const SysTray = Revealer({
  transition: 'slide_right',
  connections: [[SystemTray, rev => {
    rev.revealChild = rev.child.children[0].get_children().length > 0;
  }]],
  child: Box({
    children: [
      Box({
        className: 'sys-tray',
        children: [
          Widget({
            type: Gtk.MenuBar,
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
                widget.child.revealChild = true;
              }],

              ['onRemoved', (box, id) => {
                if (!box._items.has(id))
                  return;

                box._items.get(id).child.revealChild = false;
                setTimeout(() => {
                  box._items.get(id).destroy();
                  box._items.delete(id);
                }, 400);
              }],
            ],
            connections: [
              [SystemTray, (box, id) => box._onAdded(box, id), 'added'],
              [SystemTray, (box, id) => box._onRemoved(box, id), 'removed'],
            ],
          }),
        ],
      }),
      Separator(12),
    ],
  }),
});

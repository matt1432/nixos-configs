import { SystemTray, Widget } from '../../imports.js';
const { Box, Revealer, Icon, MenuItem } = Widget;

import Gtk from 'gi://Gtk';

import Separator from '../misc/separator.js';


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

const SysTray = () => {
  let widget = Gtk.MenuBar.new();

  // Properties
  widget._items = new Map();

  widget._onAdded = (id) => {
    const item = SystemTray.getItem(id);
    if (widget._items.has(id) || !item)
      return;

    const w = SysTrayItem(item);
    widget._items.set(id, w);
    widget.add(w);
    widget.show_all();
    w.child.revealChild = true;
  };

  widget._onRemoved = (id) => {
    if (!widget._items.has(id))
      return;

    widget._items.get(id).child.revealChild = false;
    setTimeout(() => {
      widget._items.get(id).destroy();
      widget._items.delete(id);
    }, 400);
  };

  // Connections
  SystemTray.connect('added', (_, id) => widget._onAdded(id));
  SystemTray.connect('removed', (_, id) => widget._onRemoved(id));

  return widget;
}

export default () => Revealer({
  transition: 'slide_right',
  connections: [[SystemTray, rev => {
    rev.revealChild = rev.child.children[0].get_children().length > 0;
  }]],
  child: Box({
    children: [
      Box({
        className: 'sys-tray',
        children: [
          SysTray(),
        ],
      }),
      Separator(12),
    ],
  }),
});

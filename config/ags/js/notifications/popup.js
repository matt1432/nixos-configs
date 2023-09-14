import Notification from './base.js';
const { Notifications } = ags.Service;
const { Box, Revealer, Window } = ags.Widget;
const { timeout, interval } = ags.Utils;
const { source_remove } = imports.gi.GLib;

const Popups = () => Box({
  vertical: true,
  properties: [
    ['map', new Map()],
    ['dismiss', (box, id, force = false) => {
      if (!id || !box._map.has(id))
        return;

      if (box._map.get(id)._hovered && !force)
        return;

      if (box._map.size - 1 === 0)
        box.get_parent().reveal_child = false;

      timeout(200, () => {
        if (box._map.get(id).interval) {
          source_remove(box._map.get(id).interval);
          box._map.get(id).interval = undefined;
        }
        box._map.get(id)?.destroy();
        box._map.delete(id);
      });
    }],
    ['notify', (box, id) => {
      if (!id || Notifications.dnd)
        return;

      box._map.delete(id);

      box._map.set(id, Notification({
        ...Notifications.getNotification(id),
        command: i => Notifications.dismiss(i),
      }));

      box.children = Array.from(box._map.values()).reverse();
      timeout(10, () => {
          box.get_parent().revealChild = true;
      });
      box._map.get(id).interval = interval(4500, () => {
        if (!box._map.get(id)._hovered) {
          box._map.get(id).child.setStyle(box._map.get(id).child._leftAnim);

          if (box._map.get(id).interval) {
            source_remove(box._map.get(id).interval);
            box._map.get(id).interval = undefined;
          }
        }
      });
    }],
  ],
  connections: [
    [Notifications, (box, id) => box._notify(box, id), 'notified'],
    [Notifications, (box, id) => box._dismiss(box, id), 'dismissed'],
    [Notifications, (box, id) => box._dismiss(box, id, true), 'closed'],
  ],
});

const PopupList = ({ transition = 'none' } = {}) => Box({
  className: 'notifications-popup-list',
  style: 'padding: 1px',
  children: [
    Revealer({
      transition,
      child: Popups(),
    }),
  ],
});

export const NotificationsPopupList = Window({
  name: `notifications`,
  anchor: 'top left',
  child: PopupList(),
});

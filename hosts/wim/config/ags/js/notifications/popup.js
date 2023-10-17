import { Notifications, Widget } from '../../imports.js';
const { Box, Revealer, Window } = Widget;

import Notification from './base.js';


const Popups = () => Box({
  vertical: true,
  properties: [
    ['map', new Map()],

    ['dismiss', (box, id, force = false) => {
      if (!id || !box._map.has(id) ||
          box._map.get(id)._hovered && !force) {

        return;
      }

      if (box._map.size - 1 === 0)
        box.get_parent().reveal_child = false;

      setTimeout(() => {
        if (box._map.get(id)?.interval) {
          box._map.get(id).interval.destroy();
          box._map.get(id).interval = undefined;
        }
        box._map.get(id)?.destroy();
        box._map.delete(id);
      }, 200);
    }],

    ['notify', (box, id) => {
      if (!id || Notifications.dnd)
        return;

      if (! Notifications.getNotification(id))
        return;

      box._map.delete(id);

      let notif = Notifications.getNotification(id);
      box._map.set(id, Notification({
        notif,
        command: () => notif.dismiss(),
      }));

      box.children = Array.from(box._map.values()).reverse();

      setTimeout(() => {
          box.get_parent().revealChild = true;
      }, 10);

      box._map.get(id).interval = setInterval(() => {
        if (!box._map.get(id)._hovered) {
          box._map.get(id).child.setStyle(box._map.get(id).child._leftAnim1);

          if (box._map.get(id).interval) {
            box._map.get(id).interval.destroy();
            box._map.get(id).interval = undefined;
          }
        }
      }, 4500);
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

export default () => Window({
  name: `notifications`,
  anchor: [ 'top', 'left' ],
  child: PopupList(),
});

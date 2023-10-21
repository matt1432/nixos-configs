import { Notifications, Utils, Widget } from '../../imports.js';
const { Box, Revealer, Window } = Widget;

import GLib from 'gi://GLib';

import Notification from './base.js';


const Popups = () => Box({
    vertical: true,
    properties: [
        ['map', new Map()],

        ['dismiss', (box, id, force = false) => {
            if (!id || !box._map.has(id) ||
          box._map.get(id)._hovered && !force)

                return;


            if (box._map.size - 1 === 0)
                box.get_parent().reveal_child = false;

            Utils.timeout(200, () => {
                if (box._map.get(id)?.interval) {
                    box._map.get(id).interval.destroy();
                    box._map.get(id).interval = undefined;
                }
                box._map.get(id)?.destroy();
                box._map.delete(id);
            });
        }],

        ['notify', (box, id) => {
            if (!id || Notifications.dnd)
                return;

            if (! Notifications.getNotification(id))
                return;

            box._map.delete(id);

            const notif = Notifications.getNotification(id);
            box._map.set(id, Notification({
                notif,
                command: () => notif.dismiss(),
            }));

            box.children = Array.from(box._map.values()).reverse();

            Utils.timeout(10, () => {
                box.get_parent().revealChild = true;
            });

            box._map.get(id).interval = Utils.interval(4500, () => {
                if (!box._map.get(id)._hovered) {
                    box._map.get(id).child.setStyle(box._map.get(id).child._leftAnim1);

                    if (box._map.get(id).interval) {
                        GLib.source_remove(box._map.get(id).interval);
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

export default () => Window({
    name: 'notifications',
    anchor: ['top', 'left'],
    child: PopupList(),
});

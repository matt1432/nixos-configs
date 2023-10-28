import { Notifications, Utils, Widget } from '../../imports.js';
const { Box, Revealer, Window } = Widget;

import GLib from 'gi://GLib';

import Notification from './base.js';


const Popups = () => Box({
    vertical: true,
    properties: [
        ['map', new Map()],

        ['dismiss', (box, id, force = false) => {
            if (!id || !box._map.has(id) || box._map.get(id)._hovered && !force)
                return;

            if (box._map.size - 1 === 0)
                box.get_parent().reveal_child = false;

            Utils.timeout(200, () => {
                const notif = box._map.get(id);
                if (notif.interval) {
                    GLib.source_remove(notif.interval);
                    notif.interval = undefined;
                }
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
                const notif = box._map.get(id);
                if (!notif._hovered) {
                    notif.child.setStyle(notif.child._leftAnim1);

                    if (notif.interval) {
                        Utils.timeout(500, () => notif.destroy());
                        GLib.source_remove(notif.interval);
                        notif.interval = undefined;
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

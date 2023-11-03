import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';
import { Box, Revealer, Window } from 'resource:///com/github/Aylur/ags/widget.js';
import { interval, timeout } from 'resource:///com/github/Aylur/ags/utils.js';

import GLib from 'gi://GLib';

import Notification from './base.js';


// TODO: clean up code
const Popups = () => Box({
    vertical: true,
    properties: [
        ['notify', (box, id) => {
            if (id) {
                const notif = Notifications.getNotification(id);

                const NewNotif = Notification({
                    notif,
                    command: () => notif.dismiss(),
                });

                if (NewNotif) {
                    box.pack_end(NewNotif, false, false, 0);
                    box.show_all();
                }
            }
        }],

        ['dismiss', (box, id, force = false) => {
            for (const ch of box.children) {
                if (ch._id == id) {
                    if (!ch._hovered || force) {
                        ch.child.setStyle(ch.child._slideLeft);
                        ch.sensitive = false;
                        timeout(400, () => {
                            ch.child.setStyle(ch.child._squeezeLeft);
                            timeout(500, () => box.remove(ch));
                        });
                        return;
                    }
                    else if (ch._hovered) {
                        ch.interval = interval(2000, () => {
                            if (!ch._hovered) {
                                if (ch.interval) {
                                    ch.child.setStyle(ch.child._slideLeft);
                                    ch.sensitive = false;
                                    timeout(400, () => {
                                        ch.child.setStyle(ch.child._squeezeLeft);
                                        timeout(500, () => box.remove(ch));
                                    });
                                    GLib.source_remove(ch.interval);
                                    ch.interval = undefined;
                                }
                            }
                        });
                    }
                }
            }
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
            connections: [[Notifications, self => {
                self.revealChild = self.child.children.length > 0;
            }]],
            child: Popups(),
        }),
    ],
});

export default () => Window({
    name: 'notifications',
    anchor: ['top', 'left'],
    child: PopupList(),
});

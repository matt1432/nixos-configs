import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';
import { Box, Window } from 'resource:///com/github/Aylur/ags/widget.js';
import { interval } from 'resource:///com/github/Aylur/ags/utils.js';

import GLib from 'gi://GLib';

import { Notification } from './base.js';


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
                    // use this instead of add to put it at the top
                    box.pack_end(NewNotif, false, false, 0);
                    box.show_all();
                }
            }
        }],

        ['dismiss', (box, id, force = false) => {
            for (const ch of box.children) {
                if (ch._id == id) {
                    // If notif isn't hovered or was closed, slide away
                    if (!ch._hovered || force) {
                        ch.slideAway('Left');
                        return;
                    }

                    // If notif is hovered, delay close
                    else if (ch._hovered) {
                        ch.interval = interval(2000, () => {
                            if (!ch._hovered && ch.interval) {
                                ch.slideAway('Left');

                                GLib.source_remove(ch.interval);
                                ch.interval = undefined;
                                return;
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

export default () => Window({
    name: 'notifications',
    anchor: ['top', 'left'],
    child: Box({
        style: `min-height:1px;
                min-width:1px;
                padding: 1px;`,
        children: [Popups()],
    }),
});

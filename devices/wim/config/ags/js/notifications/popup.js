import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';

import { Box } from 'resource:///com/github/Aylur/ags/widget.js';
import { interval } from 'resource:///com/github/Aylur/ags/utils.js';

import GLib from 'gi://GLib';

import { Notification } from './base.js';

const DELAY = 2000;


export default () => Box({
    vertical: true,

    setup: (self) => {
        const addPopup = (id) => {
            if (!id) {
                return;
            }

            const notif = Notifications.getNotification(id);

            const NewNotif = Notification({
                notif,
                command: () => notif.dismiss(),
            });

            if (NewNotif) {
                // Use this instead of add to put it at the top
                self.pack_end(NewNotif, false, false, 0);
                self.show_all();
            }
        };

        const handleDismiss = (id, force = false) => {
            const notif = self.children.find((ch) => ch._id === id);

            if (!notif) {
                return;
            }

            // If notif isn't hovered or was closed, slide away
            if (!notif._hovered || force) {
                notif.slideAway('Left');
            }

            // If notif is hovered, delay close
            else if (notif._hovered) {
                notif.interval = interval(DELAY, () => {
                    if (!notif._hovered && notif.interval) {
                        notif.slideAway('Left');

                        GLib.source_remove(notif.interval);
                        notif.interval = null;
                    }
                });
            }
        };

        self
            .hook(Notifications, (_, id) => addPopup(id), 'notified')
            .hook(Notifications, (_, id) => handleDismiss(id), 'dismissed')
            .hook(Notifications, (_, id) => handleDismiss(id, true), 'closed');
    },
});

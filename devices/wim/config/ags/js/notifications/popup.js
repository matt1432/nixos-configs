import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';

import { Box } from 'resource:///com/github/Aylur/ags/widget.js';
import { interval } from 'resource:///com/github/Aylur/ags/utils.js';

import GLib from 'gi://GLib';

import { Notification } from './base.js';

const DELAY = 2000;


const addPopup = (box, id) => {
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
        box.pack_end(NewNotif, false, false, 0);
        box.show_all();
    }
};

const handleDismiss = (box, id, force = false) => {
    const notif = box.children.find((ch) => ch._id === id);

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

export default () => Box({
    vertical: true,

    connections: [
        [Notifications, (s, id) => addPopup(s, id), 'notified'],
        [Notifications, (s, id) => handleDismiss(s, id), 'dismissed'],
        [Notifications, (s, id) => handleDismiss(s, id, true), 'closed'],
    ],
});

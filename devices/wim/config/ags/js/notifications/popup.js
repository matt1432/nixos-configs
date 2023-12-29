import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';

import { Box } from 'resource:///com/github/Aylur/ags/widget.js';
import { interval } from 'resource:///com/github/Aylur/ags/utils.js';

import GLib from 'gi://GLib';

import { Notification } from './base.js';

const DELAY = 2000;


export default () => Box({
    vertical: true,
    // Needed so it occupies space at the start
    css: 'padding: 1px;',

    setup: (self) => {
        /** @param {number} id */
        const addPopup = (id) => {
            if (!id) {
                return;
            }

            const notif = Notifications.getNotification(id);

            if (notif) {
                const NewNotif = Notification({
                    notif,
                    command: () => {
                        if (notif.popup) {
                            notif.dismiss();
                        }
                    },
                });

                if (NewNotif) {
                    // Use this instead of add to put it at the top
                    self.pack_end(NewNotif, false, false, 0);
                    self.show_all();
                }
            }
        };

        /**
         * @param {number} id
         * @param {boolean} force
         */
        const handleDismiss = (id, force = false) => {
            // @ts-expect-error
            const notif = self.children.find((ch) => ch.attribute.id === id);

            if (!notif) {
                return;
            }

            // If notif isn't hovered or was closed, slide away
            // @ts-expect-error
            if (!notif.attribute.hovered || force) {
                // @ts-expect-error
                notif.attribute.slideAway('Left');
            }

            // If notif is hovered, delay close
            // @ts-expect-error
            else if (notif.attribute.hovered) {
                const intervalId = interval(DELAY, () => {
                    // @ts-expect-error
                    if (!notif.attribute.hovered && intervalId) {
                        // @ts-expect-error
                        notif.attribute.slideAway('Left');

                        GLib.source_remove(intervalId);
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

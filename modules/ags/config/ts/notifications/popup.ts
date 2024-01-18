import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';

import { Box } from 'resource:///com/github/Aylur/ags/widget.js';
import { interval } from 'resource:///com/github/Aylur/ags/utils.js';

import GLib from 'gi://GLib';

import { Notification } from './base.ts';

const DELAY = 2000;

// Types
import AgsBox from 'types/widgets/box.ts';


export default () => Box({
    vertical: true,
    // Needed so it occupies space at the start
    css: 'padding: 1px;',

    setup: (self) => {
        const addPopup = (id: number) => {
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

        const handleDismiss = (id: number, force = false) => {
            const notif = (self.children as Array<AgsBox>)
                .find((ch) => ch.attribute.id === id);

            if (!notif) {
                return;
            }

            // If notif isn't hovered or was closed, slide away
            if (!notif.attribute.hovered || force) {
                notif.attribute.slideAway('Left');
            }

            // If notif is hovered, delay close
            else if (notif.attribute.hovered) {
                const intervalId = interval(DELAY, () => {
                    if (!notif.attribute.hovered && intervalId) {
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

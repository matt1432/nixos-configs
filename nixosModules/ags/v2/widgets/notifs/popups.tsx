import AstalNotifd from 'gi://AstalNotifd?version=0.1';
const Notifications = AstalNotifd.get_default();

import { NotifGestureWrapper } from './gesture';
import { Notification } from './notification';


export default () => (
    <box
        // Needed so it occupies space at the start
        // It needs to be bigger than the notifs to not jiggle
        css="min-width: 550px;"
        vertical

        setup={(self) => {
            const notifQueue: number[] = [];

            const addPopup = (id: number) => {
                if (!id) {
                    return;
                }

                if (NotifGestureWrapper.sliding_in === 0) {
                    const NewNotif = Notification({ id, popup_timer: 5 });

                    if (NewNotif) {
                        // Use this instead of add to put it at the top
                        self.pack_end(NewNotif, false, false, 0);
                        self.show_all();

                        NotifGestureWrapper.popups.set(id, NewNotif);
                    }
                }
                else {
                    notifQueue.push(id);
                }
            };

            NotifGestureWrapper.on_sliding_in = (n) => {
                if (n === 0) {
                    const id = notifQueue.shift();

                    if (id) {
                        addPopup(id);
                    }
                }
            };

            const handleResolved = (id: number) => {
                const notif = NotifGestureWrapper.popups.get(id);

                if (!notif) {
                    return;
                }

                notif.slideAway('Left');
                NotifGestureWrapper.popups.delete(id);
            };

            self
                .hook(Notifications, 'notified', (_, id) => addPopup(id))
                .hook(Notifications, 'resolved', (_, id) => handleResolved(id));
        }}
    />
);

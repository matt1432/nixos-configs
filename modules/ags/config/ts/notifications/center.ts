const Notifications = await Service.import('notifications');

const { Label, Box, Icon, Scrollable, Revealer } = Widget;
const { timeout } = Utils;

import { Notification, HasNotifs } from './base.ts';
import CursorBox from '../misc/cursorbox.ts';

// Types
import { Notification as NotifObj } from 'resource:///com/github/Aylur/ags/service/notifications.js';
import { BoxGeneric, NotifGesture } from 'global-types';


const addNotif = (box: BoxGeneric, notif: NotifObj) => {
    if (notif) {
        const NewNotif = Notification({
            notif,
            slideIn: 'Right',
            command: () => notif.close(),
        });

        if (NewNotif) {
            box.pack_end(NewNotif, false, false, 0);
            box.show_all();
        }
    }
};

const NotificationList = () => Box({
    vertical: true,
    vexpand: true,
    vpack: 'start',
    visible: HasNotifs.bind(),

    setup: (self) => {
        const initNotifId = 1337;
        const delay = 2000;

        // Fix the no notif placement with a fake notif
        Notifications.Notify('', initNotifId, '', '', '', [''], {}, 0);
        setTimeout(() => {
            Notifications.getNotification(initNotifId)?.close();
        }, delay);

        self
            .hook(Notifications, (box, id) => {
                // Handle cached notifs
                if (box.children.length === 0) {
                    Notifications.notifications.forEach((n) => {
                        addNotif(box, n);
                    });
                }

                else if (id) {
                    const notifObj = Notifications.getNotification(id);

                    if (notifObj) {
                        addNotif(box, notifObj);
                    }
                }
            }, 'notified')

            .hook(Notifications, (box, id) => {
                const notif = (box.children as NotifGesture[])
                    .find((ch) => ch.attribute.id === id);

                if (notif?.sensitive) {
                    notif.attribute.slideAway('Right');
                }
            }, 'closed');
    },
});

const ClearButton = () => CursorBox({
    class_name: 'clear',

    on_primary_click_release: () => {
        Notifications.clear();
        timeout(1000, () => App.closeWindow('win-notification-center'));
    },

    setup: (self) => {
        self.hook(HasNotifs, () => {
            self.disabled = !HasNotifs.value;
        });
    },

    child: Box({

        children: [
            Label('Clear '),

            Icon({
                setup: (self) => {
                    self.hook(Notifications, () => {
                        self.icon = Notifications.notifications.length > 0 ?
                            'user-trash-full-symbolic' :
                            'user-trash-symbolic';
                    });
                },
            }),
        ],
    }),
});

const Header = () => Box({
    class_name: 'header',
    children: [
        Label({
            label: 'Notifications',
            hexpand: true,
            xalign: 0,
        }),
        ClearButton(),
    ],
});

const Placeholder = () => Revealer({
    transition: 'crossfade',
    reveal_child: HasNotifs.bind()
        .transform((v) => !v),

    child: Box({
        class_name: 'placeholder',
        vertical: true,
        vpack: 'center',
        hpack: 'center',
        vexpand: true,
        hexpand: true,

        children: [
            Icon('notification-disabled-symbolic'),
            Label('Your inbox is empty'),
        ],
    }),
});

export default () => Box({
    class_name: 'notification-center',
    vertical: true,
    children: [
        Header(),

        Box({
            class_name: 'notification-wallpaper-box',

            children: [
                Scrollable({
                    class_name: 'notification-list-box',
                    hscroll: 'never',
                    vscroll: 'automatic',

                    child: Box({
                        class_name: 'notification-list',
                        vertical: true,

                        children: [
                            NotificationList(),

                            Placeholder(),
                        ],
                    }),
                }),
            ],
        }),
    ],
});

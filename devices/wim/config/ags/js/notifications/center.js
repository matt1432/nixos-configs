import App           from 'resource:///com/github/Aylur/ags/app.js';
import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';
import { Button, Label, Box, Icon, Scrollable, Revealer } from 'resource:///com/github/Aylur/ags/widget.js';
import { timeout } from 'resource:///com/github/Aylur/ags/utils.js';

import Notification from './base.js';
import PopupWindow  from '../misc/popup.js';
import EventBox     from '../misc/cursorbox.js';


const ClearButton = () => EventBox({
    child: Button({
        onPrimaryClickRelease: button => {
            button._popups.children.forEach(ch => {
                ch.child.setStyle(ch.child._slideLeft);
                ch.sensitive = false;
            });

            button._notifList.children.forEach(ch => {
                if (ch.child) {
                    ch.child.setStyle(ch.child._slideRight);
                    ch.sensitive = false;
                }
                timeout(500, () => {
                    button._notifList.remove(ch);
                    Notifications.clear();
                });
            });
        },
        properties: [
            ['notifList'],
            ['popups'],
        ],
        connections: [[Notifications, button => {
            if (!button._notifList)
                button._notifList = NotificationList;

            if (!button._popups)
                button._popups = App.getWindow('notifications').child.children[0].child;

            button.sensitive = Notifications.notifications.length > 0;
        }]],
        child: Box({
            children: [
                Label('Clear '),
                Icon({
                    connections: [[Notifications, self => {
                        self.icon = Notifications.notifications.length > 0
                            ? 'user-trash-full-symbolic' : 'user-trash-symbolic';
                    }]],
                }),
            ],
        }),
    }),
});

const Header = () => Box({
    className: 'header',
    children: [
        Label({
            label: 'Notifications',
            hexpand: true,
            xalign: 0,
        }),
        ClearButton(),
    ],
});

const NotificationList = Box({
    vertical: true,
    valign: 'start',
    vexpand: true,
    connections: [
        [Notifications, (box, id) => {
            if (box.children.length == 0) {
                for (const notif of Notifications.notifications) {
                    const NewNotif = Notification({
                        notif,
                        command: () => notif.close(),
                    });

                    if (NewNotif) {
                        box.pack_end(NewNotif, false, false, 0);
                        box.show_all();
                    }
                }
            }
            else if (id) {
                const notif = Notifications.getNotification(id);

                const NewNotif = Notification({
                    notif,
                    command: () => notif.close(),
                });

                if (NewNotif) {
                    box.pack_end(NewNotif, false, false, 0);
                    box.show_all();
                }
            }
        }, 'notified'],

        [Notifications, (box, id) => {
            for (const ch of box.children) {
                if (ch._id == id) {
                    ch.child.setStyle(ch.child._slideRight);
                    ch.sensitive = false;
                    timeout(500, () => box.remove(ch));
                    return;
                }
            }
        }, 'closed'],

        [Notifications, box => box.visible = Notifications.notifications.length > 0],
    ],
});

const Placeholder = () => Revealer({
    transition: 'crossfade',
    connections: [[Notifications, box => {
        box.revealChild = Notifications.notifications.length === 0;
    }]],
    child: Box({
        className: 'placeholder',
        vertical: true,
        valign: 'center',
        halign: 'center',
        vexpand: true,
        hexpand: true,
        children: [
            Icon('notification-disabled-symbolic'),
            Label('Your inbox is empty'),
        ],
    }),
});

const NotificationCenterWidget = () => Box({
    className: 'notification-center',
    vertical: true,
    children: [
        Header(),
        Box({
            className: 'notification-wallpaper-box',
            children: [
                Scrollable({
                    className: 'notification-list-box',
                    hscroll: 'never',
                    child: Box({
                        className: 'notification-list',
                        vertical: true,
                        children: [
                            NotificationList,
                            Placeholder(),
                        ],
                    }),
                }),
            ],
        }),
    ],
});

export default () => PopupWindow({
    name: 'notification-center',
    anchor: ['top', 'right'],
    margin: [6, 60, 0, 0],
    child: NotificationCenterWidget(),
});

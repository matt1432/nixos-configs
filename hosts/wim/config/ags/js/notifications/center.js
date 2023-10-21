import { Notifications, App, Utils, Widget } from '../../imports.js';
const { Button, Label, Box, Icon, Scrollable, Revealer } = Widget;
const { timeout } = Utils;

import Notification from './base.js';
import PopupWindow  from '../misc/popup.js';
import EventBox     from '../misc/cursorbox.js';


const ClearButton = () => EventBox({
    child: Button({
        onPrimaryClickRelease: button => {
            button._popups.children.forEach(ch => {
                ch.child.setStyle(ch.child._leftAnim1);
            });

            button._notifList.children.forEach(ch => {
                if (ch.child)
                    ch.child.setStyle(ch.child._rightAnim1);
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
    vexpand: true,
    connections: [
        [Notifications, (box, id) => {
            if (box.children.length == 0) {
                box.children = Notifications.notifications
                    .reverse()
                    .map(n => Notification({ notif: n, command: () => n.close() }));
            }
            else if (id) {
                const notif = Notifications.getNotification(id);

                const NewNotif = Notification({
                    notif,
                    command: () => notif.close(),
                });

                if (NewNotif) {
                    box.add(NewNotif);
                    box.show_all();
                }
            }
        }, 'notified'],

        [Notifications, (box, id) => {
            for (const ch of box.children) {
                if (ch._id == id) {
                    ch.child.setStyle(ch.child._rightAnim1);
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
                    vscroll: 'automatic',
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
    margin: [8, 60, 0, 0],
    child: NotificationCenterWidget(),
});

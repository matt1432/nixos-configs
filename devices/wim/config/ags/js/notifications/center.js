import App from 'resource:///com/github/Aylur/ags/app.js';
import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';

import { Button, Label, Box, Icon, Scrollable, Revealer } from 'resource:///com/github/Aylur/ags/widget.js';
import { timeout } from 'resource:///com/github/Aylur/ags/utils.js';

import { Notification, HasNotifs } from './base.js';
import CursorBox from '../misc/cursorbox.js';


const addNotif = (box, notif) => {
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
    binds: [['visible', HasNotifs]],

    setup: (self) => {
        self
            .hook(Notifications, (box, id) => {
                // Handle cached notifs
                if (box.children.length === 0) {
                    Notifications.notifications.forEach((n) => {
                        addNotif(box, n);
                    });
                }

                else if (id) {
                    addNotif(box, Notifications.getNotification(id));
                }
            }, 'notified')

            .hook(Notifications, (box, id) => {
                const notif = box.children.find((ch) => ch._id === id);

                if (notif?.sensitive) {
                    notif.slideAway('Right');
                }
            }, 'closed');
    },
});

// Needs to be wrapped to still have onHover when disabled
const ClearButton = () => CursorBox({
    child: Button({
        onPrimaryClickRelease: () => {
            Notifications.clear();
            timeout(1000, () => App.closeWindow('notification-center'));
        },
        binds: [['sensitive', HasNotifs]],
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

const Placeholder = () => Revealer({
    transition: 'crossfade',
    binds: [['revealChild', HasNotifs, 'value', (value) => !value]],
    child: Box({
        className: 'placeholder',
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
                            NotificationList(),
                            Placeholder(),
                        ],
                    }),
                }),
            ],
        }),
    ],
});

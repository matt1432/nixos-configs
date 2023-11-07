import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';
import { Button, Label, Box, Icon, Scrollable, Revealer } from 'resource:///com/github/Aylur/ags/widget.js';

import { Notification, HasNotifs } from './base.js';
import PopupWindow from '../misc/popup.js';
import EventBox    from '../misc/cursorbox.js';


const addNotif = (box, notif) => {
    if (!notif)
        return;

    const NewNotif = Notification({
        notif,
        slideIn: 'Right',
        command: () => notif.close(),
    });

    if (NewNotif) {
        box.pack_end(NewNotif, false, false, 0);
        box.show_all();
    }
};

const NotificationList = () => Box({
    vertical: true,
    vexpand: true,
    vpack: 'start',
    binds: [['visible', HasNotifs]],
    setup: box => {
        // Get cached notifications
        const id = Notifications.connect('changed', () => {
            Notifications.notifications.forEach(notif => {
                addNotif(box, notif);
            });
            Notifications.disconnect(id);
        });
    },
    connections: [
        [Notifications, (box, id) => {
            if (!id)
                return;

            addNotif(box, Notifications.getNotification(id));
        }, 'notified'],

        [Notifications, (box, id) => {
            const notif = box.children.find(ch => ch._id === id);
            if (notif?.sensitive)
                notif.slideAway('Right');
        }, 'closed'],
    ],
});

// Needs to be wrapped to still have onHover when disabled
const ClearButton = () => EventBox({
    child: Button({
        onPrimaryClickRelease: () => Notifications.clear(),
        binds: [['sensitive', HasNotifs]],
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

const Placeholder = () => Revealer({
    transition: 'crossfade',
    binds: [['revealChild', HasNotifs, 'value', value => !value]],
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
                            NotificationList(),
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
    margins: [6, 60, 0, 0],
    child: NotificationCenterWidget(),
});

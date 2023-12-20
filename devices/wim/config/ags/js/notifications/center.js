import App from 'resource:///com/github/Aylur/ags/app.js';
import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';

import { Button, Label, Box, Icon, Scrollable, Revealer } from 'resource:///com/github/Aylur/ags/widget.js';
import { timeout } from 'resource:///com/github/Aylur/ags/utils.js';

import { Notification, HasNotifs } from './base.js';
import CursorBox from '../misc/cursorbox.js';

/**
 * @typedef {import('types/service/notifications').Notification} NotifObj
 * @typedef {import('types/widgets/box').default} Box
 */


/**
 * @param {Box} box
 * @param {NotifObj} notif
 */
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
    visible: HasNotifs.bind(),

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
                    const notifObj = Notifications.getNotification(id);

                    if (notifObj) {
                        addNotif(box, notifObj);
                    }
                }
            }, 'notified')

            .hook(Notifications, (box, id) => {
                // @ts-expect-error
                const notif = box.children.find((ch) => ch.attribute.id === id);

                if (notif?.sensitive) {
                    // @ts-expect-error
                    notif.attribute.slideAway('Right');
                }
            }, 'closed');
    },
});

// TODO: use cursorbox feature for this
// Needs to be wrapped to still have onHover when disabled
const ClearButton = () => CursorBox({
    child: Button({
        sensitive: HasNotifs.bind(),

        on_primary_click_release: () => {
            Notifications.clear();
            timeout(1000, () => App.closeWindow('notification-center'));
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

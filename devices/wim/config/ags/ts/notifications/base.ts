import Applications from 'resource:///com/github/Aylur/ags/service/applications.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';

import { Box, Icon, Label, Button } from 'resource:///com/github/Aylur/ags/widget.js';
import { lookUpIcon } from 'resource:///com/github/Aylur/ags/utils.js';

const { GLib } = imports.gi;

import Gesture from './gesture.ts';
import CursorBox from '../misc/cursorbox.ts';

// Types
import { Notification as NotifObj } from 'types/service/notifications.ts';
import AgsEventBox from 'types/widgets/eventbox.ts';
import { Client } from 'types/service/hyprland.ts';
type NotificationWidget = {
    notif: NotifObj
    slideIn?: 'Left' | 'Right'
    command?(): void
};

const setTime = (time: number) => {
    return GLib.DateTime
        .new_from_unix_local(time)
        .format('%H:%M');
};

const getDragState = (box: AgsEventBox) => (box.get_parent()?.get_parent()
    ?.get_parent()?.get_parent()?.get_parent() as AgsEventBox)
    ?.attribute.dragging;


const NotificationIcon = (notif: NotifObj) => {
    let iconCmd = (box: AgsEventBox):void => {
        console.log(box);
    };

    if (notif.app_entry && Applications.query(notif.app_entry).length > 0) {
        const app = Applications.query(notif.app_entry)[0];

        let wmClass = app.app.get_string('StartupWMClass');

        if (app.app?.get_filename()?.includes('discord')) {
            wmClass = 'discord';
        }

        if (wmClass != null) {
            iconCmd = (box) => {
                if (!getDragState(box)) {
                    if (wmClass === 'thunderbird') {
                        Hyprland.sendMessage('dispatch ' +
                            'togglespecialworkspace thunder');
                    }
                    else if (wmClass === 'Spotify') {
                        Hyprland.sendMessage('dispatch ' +
                            'togglespecialworkspace spot');
                    }
                    else {
                        Hyprland.sendMessage('j/clients').then((msg) => {
                            const clients = JSON.parse(msg) as Array<Client>;
                            const classes = [] as Array<string>;

                            for (const key of clients) {
                                if (key.class) {
                                    classes.push(key.class);
                                }
                            }

                            if (wmClass && classes.includes(wmClass)) {
                                Hyprland.sendMessage('dispatch ' +
                                    `focuswindow ^(${wmClass})`);
                            }
                            else {
                                Hyprland.sendMessage('dispatch workspace empty')
                                    .then(() => {
                                        app.launch();
                                    });
                            }
                        });
                    }

                    globalThis.closeAll();
                }
            };
        }
    }

    if (notif.image) {
        return CursorBox({
            on_primary_click_release: iconCmd,

            child: Box({
                vpack: 'start',
                hexpand: false,
                class_name: 'icon img',
                css: `
                    background-image: url("${notif.image}");
                    background-size: contain;
                    background-repeat: no-repeat;
                    background-position: center;
                    min-width: 78px;
                    min-height: 78px;
                `,
            }),
        });
    }

    let icon = 'dialog-information-symbolic';

    if (lookUpIcon(notif.app_icon)) {
        icon = notif.app_icon;
    }


    if (notif.app_entry && lookUpIcon(notif.app_entry)) {
        icon = notif.app_entry;
    }


    return CursorBox({
        on_primary_click_release: iconCmd,

        child: Box({
            vpack: 'start',
            hexpand: false,
            class_name: 'icon',
            css: `
                min-width: 78px;
                min-height: 78px;
            `,
            children: [Icon({
                icon, size: 58,
                hpack: 'center',
                hexpand: true,
                vpack: 'center',
                vexpand: true,
            })],
        }),
    });
};

// Make a variable to connect to for Widgets
// to know when there are notifs or not
export const HasNotifs = Variable(false);

export const Notification = ({
    notif,
    slideIn = 'Left',
    command = () => {/**/},
}: NotificationWidget) => {
    if (!notif) {
        return;
    }

    const BlockedApps = [
        'Spotify',
    ];

    if (BlockedApps.find((app) => app === notif.app_name)) {
        notif.close();

        return;
    }

    HasNotifs.value = Notifications.notifications.length > 0;

    // Init notif
    const notifWidget = Gesture({
        command,
        slideIn,
        id: notif.id,
    });

    // Add body to notif
    (notifWidget.child as AgsEventBox).add(Box({
        class_name: `notification ${notif.urgency}`,
        vexpand: false,

        // Notification
        child: Box({
            vertical: true,
            children: [

                // Content
                Box({
                    children: [
                        NotificationIcon(notif),

                        Box({
                            hexpand: true,
                            vertical: true,
                            children: [

                                // Top of Content
                                Box({
                                    children: [

                                        // Title
                                        Label({
                                            class_name: 'title',
                                            xalign: 0,
                                            justification: 'left',
                                            hexpand: true,
                                            max_width_chars: 24,
                                            truncate: 'end',
                                            wrap: true,
                                            label: notif.summary,
                                            use_markup: notif.summary
                                                .startsWith('<'),
                                        }),

                                        // Time
                                        Label({
                                            class_name: 'time',
                                            vpack: 'start',
                                            label: setTime(notif.time),
                                        }),

                                        // Close button
                                        CursorBox({
                                            child: Button({
                                                class_name: 'close-button',
                                                vpack: 'start',

                                                on_primary_click_release: () =>
                                                    notif.close(),

                                                child: Icon('window-close' +
                                                    '-symbolic'),
                                            }),
                                        }),
                                    ],
                                }),

                                // Description
                                Label({
                                    class_name: 'description',
                                    hexpand: true,
                                    use_markup: true,
                                    xalign: 0,
                                    justification: 'left',
                                    label: notif.body,
                                    wrap: true,
                                }),
                            ],
                        }),
                    ],
                }),

                // Actions
                Box({
                    class_name: 'actions',
                    children: notif.actions.map((action) => Button({
                        class_name: 'action-button',
                        hexpand: true,

                        on_primary_click_release: () => notif.invoke(action.id),

                        child: Label(action.label),
                    })),
                }),
            ],
        }),
    }));

    return notifWidget;
};
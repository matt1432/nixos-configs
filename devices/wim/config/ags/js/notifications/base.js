import Applications from 'resource:///com/github/Aylur/ags/service/applications.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';

import { Box, Icon, Label, Button } from 'resource:///com/github/Aylur/ags/widget.js';
import { lookUpIcon } from 'resource:///com/github/Aylur/ags/utils.js';

import GLib from 'gi://GLib';

const setTime = (time) => {
    return GLib.DateTime
        .new_from_unix_local(time)
        .format('%H:%M');
};

const getDragState = (box) => box.get_parent().get_parent()
    .get_parent().get_parent().get_parent()._dragging;

import Gesture from './gesture.js';
import CursorBox from '../misc/cursorbox.js';


const NotificationIcon = (notif) => {
    let iconCmd = () => { /**/ };

    if (Applications.query(notif.appEntry).length > 0) {
        const app = Applications.query(notif.appEntry)[0];

        let wmClass = app.app.get_string('StartupWMClass');

        if (app.app.get_filename().includes('discord')) {
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
                        Hyprland.sendMessage('j/clients').then((out) => {
                            out = JSON.parse(out);
                            const classes = [];

                            for (const key of out) {
                                if (key.class) {
                                    classes.push(key.class);
                                }
                            }

                            if (classes.includes(wmClass)) {
                                Hyprland.sendMessage('dispatch ' +
                                    `focuswindow ^(${wmClass})`);
                            }
                            else {
                                Hyprland.sendMessage('[[BATCH]] ' +
                                    'dispatch workspace empty; ' +
                                    `dispatch exec sh -c ${app.executable}
                                `);
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
                className: 'icon img',
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

    if (lookUpIcon(notif.appIcon)) {
        icon = notif.appIcon;
    }


    if (lookUpIcon(notif.appEntry)) {
        icon = notif.appEntry;
    }


    return CursorBox({
        on_primary_click_release: iconCmd,

        child: Box({
            vpack: 'start',
            hexpand: false,
            className: 'icon',
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
    command = () => { /**/ },
} = {}) => {
    if (!notif) {
        return;
    }

    const BlockedApps = [
        'Spotify',
    ];

    if (BlockedApps.find((app) => app === notif.appName)) {
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
    notifWidget.child.add(Box({
        className: `notification ${notif.urgency}`,
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
                                            className: 'title',
                                            xalign: 0,
                                            justification: 'left',
                                            hexpand: true,
                                            maxWidthChars: 24,
                                            truncate: 'end',
                                            wrap: true,
                                            label: notif.summary,
                                            useMarkup: notif.summary
                                                .startsWith('<'),
                                        }),

                                        // Time
                                        Label({
                                            className: 'time',
                                            vpack: 'start',
                                            label: setTime(notif.time),
                                        }),

                                        // Close button
                                        CursorBox({
                                            child: Button({
                                                className: 'close-button',
                                                vpack: 'start',
                                                onClicked: () => notif.close(),
                                                child: Icon('window-close' +
                                                    '-symbolic'),
                                            }),
                                        }),
                                    ],
                                }),

                                // Description
                                Label({
                                    className: 'description',
                                    hexpand: true,
                                    useMarkup: true,
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
                    className: 'actions',
                    children: notif.actions.map((action) => Button({
                        className: 'action-button',
                        onClicked: () => notif.invoke(action.id),
                        hexpand: true,
                        child: Label(action.label),
                    })),
                }),
            ],
        }),
    }));

    return notifWidget;
};

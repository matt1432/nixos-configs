import { Gtk } from 'ags/gtk4';
import { timeout } from 'ags/time';
import AstalNotifd from 'gi://AstalNotifd';
import { createBinding } from 'gnim';

import { getWindow } from '../../lib';
import { cursor, getChildren } from '../../lib/widgets';
import NotifGestureWrapper from './gesture';
import { HasNotifs, Notification } from './notification';

const addNotif = (box: Gtk.Box, notifObj: AstalNotifd.Notification) => {
    if (notifObj) {
        const NewNotif = Notification({
            id: notifObj.id,
            slide_in_from: 'Right',
        });

        if (NewNotif) {
            // Put it at the top
            box.prepend(NewNotif);
        }
    }
};

const NotificationList = () => {
    const notifications = AstalNotifd.get_default();

    return (
        <box
            orientation={Gtk.Orientation.VERTICAL}
            vexpand
            valign={Gtk.Align.START}
            visible={HasNotifs}
            // It needs to be bigger than the notifs to not jiggle
            css="min-width: 550px;"
            $={(self) => {
                notifications.get_notifications().forEach((n) => {
                    addNotif(self, n);
                });

                notifications.connect('notified', (_, id) => {
                    if (id) {
                        const notifObj = notifications.get_notification(id);

                        if (notifObj) {
                            addNotif(self, notifObj);
                        }
                    }
                });
                notifications.connect('resolved', (_, id) => {
                    const notif = (
                        getChildren(self) as NotifGestureWrapper[]
                    ).find((ch) => ch.id === id);

                    if (notif?.get_sensitive()) {
                        notif.slideAway('Right');
                    }
                });
            }}
        />
    );
};

const ClearButton = () => {
    const notifications = AstalNotifd.get_default();

    return (
        // The button can't show a cursor while insensitive, so the
        // 'not-allowed' cursor is set on a wrapper
        <box
            cursor={HasNotifs.as((hasNotifs) =>
                cursor(hasNotifs ? 'pointer' : 'not-allowed'),
            )}
        >
            <button
                class="clear"
                sensitive={HasNotifs}
                onClicked={() => {
                    notifications.get_notifications().forEach((notif) => {
                        notif.dismiss();
                    });
                    timeout(1000, () => {
                        getWindow('win-notif-center')?.set_visible(false);
                    });
                }}
            >
                <box>
                    <label label="Clear " />

                    <image
                        iconName={createBinding(
                            notifications,
                            'notifications',
                        ).as((notifs) =>
                            notifs.length > 0
                                ? 'user-trash-full-symbolic'
                                : 'user-trash-symbolic',
                        )}
                    />
                </box>
            </button>
        </box>
    );
};

const Header = () => (
    <box class="header">
        <label label="Notifications" hexpand xalign={0} />
        <ClearButton />
    </box>
);

const Placeholder = () => (
    <revealer
        transitionType={Gtk.RevealerTransitionType.CROSSFADE}
        revealChild={HasNotifs.as((v) => !v)}
    >
        <box
            class="placeholder"
            orientation={Gtk.Orientation.VERTICAL}
            valign={Gtk.Align.CENTER}
            halign={Gtk.Align.CENTER}
            vexpand
            hexpand
        >
            <image iconName="notification-disabled-symbolic" />
            <label label="Your inbox is empty" />
        </box>
    </revealer>
);

export default () => (
    <box
        class="notification-center widget"
        orientation={Gtk.Orientation.VERTICAL}
    >
        <Header />

        <box class="notification-wallpaper-box">
            <scrolledwindow
                class="notification-list-box"
                hexpand
                vexpand
                hscrollbarPolicy={Gtk.PolicyType.NEVER}
                vscrollbarPolicy={Gtk.PolicyType.AUTOMATIC}
            >
                <box
                    class="notification-list"
                    orientation={Gtk.Orientation.VERTICAL}
                >
                    <NotificationList />

                    <Placeholder />
                </box>
            </scrolledwindow>
        </box>
    </box>
);

import { Astal, Gtk } from 'ags/gtk3';
import { timeout } from 'ags/time';
import AstalNotifd from 'gi://AstalNotifd';
import { createBinding } from 'gnim';

import { getWindow } from '../../lib';
import NotifGestureWrapper from './gesture';
import { HasNotifs, Notification } from './notification';

const addNotif = (box: Astal.Box, notifObj: AstalNotifd.Notification) => {
    if (notifObj) {
        const NewNotif = Notification({
            id: notifObj.id,
            slide_in_from: 'Right',
        });

        if (NewNotif) {
            box.pack_end(NewNotif, false, false, 0);
            box.show_all();
        }
    }
};

const NotificationList = () => {
    const notifications = AstalNotifd.get_default();

    return (
        <box
            vertical
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
                        self.get_children() as NotifGestureWrapper[]
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
        <cursor-eventbox
            cursor={HasNotifs.as((hasNotifs) =>
                hasNotifs ? 'pointer' : 'not-allowed',
            )}
        >
            <button
                class="clear"
                sensitive={HasNotifs}
                onButtonReleaseEvent={() => {
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

                    <icon
                        icon={createBinding(notifications, 'notifications').as(
                            (notifs) =>
                                notifs.length > 0
                                    ? 'user-trash-full-symbolic'
                                    : 'user-trash-symbolic',
                        )}
                    />
                </box>
            </button>
        </cursor-eventbox>
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
            vertical
            valign={Gtk.Align.CENTER}
            halign={Gtk.Align.CENTER}
            vexpand
            hexpand
        >
            <icon icon="notification-disabled-symbolic" />
            <label label="Your inbox is empty" />
        </box>
    </revealer>
);

export default () => (
    <box class="notification-center widget" vertical>
        <Header />

        <box class="notification-wallpaper-box">
            <scrollable
                class="notification-list-box"
                hscroll={Gtk.PolicyType.NEVER}
                vscroll={Gtk.PolicyType.AUTOMATIC}
            >
                <box class="notification-list" vertical>
                    <NotificationList />

                    <Placeholder />
                </box>
            </scrollable>
        </box>
    </box>
);

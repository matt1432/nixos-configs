import { bind, timeout } from 'astal';
import { App, Gtk, Widget } from 'astal/gtk3';

import AstalNotifd from 'gi://AstalNotifd';

import { Notification, HasNotifs } from './notification';
import NotifGestureWrapper from './gesture';


const addNotif = (box: Widget.Box, notifObj: AstalNotifd.Notification) => {
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
            visible={bind(HasNotifs)}
            // It needs to be bigger than the notifs to not jiggle
            css="min-width: 550px;"

            setup={(self) => {
                notifications.get_notifications().forEach((n) => {
                    addNotif(self, n);
                });

                self
                    .hook(notifications, 'notified', (_, id) => {
                        if (id) {
                            const notifObj = notifications.get_notification(id);

                            if (notifObj) {
                                addNotif(self, notifObj);
                            }
                        }
                    })
                    .hook(notifications, 'resolved', (_, id) => {
                        const notif = (self.get_children() as NotifGestureWrapper[])
                            .find((ch) => ch.id === id);

                        if (notif?.sensitive) {
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
        <eventbox
            cursor={bind(HasNotifs).as((hasNotifs) => hasNotifs ? 'pointer' : 'not-allowed')}
        >
            <button
                className="clear"
                sensitive={bind(HasNotifs)}

                onButtonReleaseEvent={() => {
                    notifications.get_notifications().forEach((notif) => {
                        notif.dismiss();
                    });
                    timeout(1000, () => {
                        App.get_window('win-notif-center')?.set_visible(false);
                    });
                }}
            >
                <box>
                    <label label="Clear " />

                    <icon icon={bind(notifications, 'notifications')
                        .as((notifs) => notifs.length > 0 ?
                            'user-trash-full-symbolic' :
                            'user-trash-symbolic')}
                    />
                </box>
            </button>
        </eventbox>
    );
};

const Header = () => (
    <box className="header">
        <label
            label="Notifications"
            hexpand
            xalign={0}
        />
        <ClearButton />
    </box>
);

const Placeholder = () => (
    <revealer
        transitionType={Gtk.RevealerTransitionType.CROSSFADE}
        revealChild={bind(HasNotifs).as((v) => !v)}
    >
        <box
            className="placeholder"
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
    <box
        className="notification-center widget"
        vertical
    >
        <Header />

        <box className="notification-wallpaper-box">
            <scrollable
                className="notification-list-box"
                hscroll={Gtk.PolicyType.NEVER}
                vscroll={Gtk.PolicyType.AUTOMATIC}
            >
                <box
                    className="notification-list"
                    vertical
                >
                    <NotificationList />

                    <Placeholder />
                </box>
            </scrollable>
        </box>
    </box>
);

import { App, Gtk, Gdk, Widget } from 'astal/gtk3';
import { Variable } from 'astal';

import GLib from 'gi://GLib';

import AstalApps from 'gi://AstalApps';
const Applications = AstalApps.Apps.new();

import AstalNotifd from 'gi://AstalNotifd';

import NotifGestureWrapper from './gesture';
// import SmoothProgress from '../misc/smooth-progress';


// Make a variable to connect to for Widgets
// to know when there are notifs or not
export const HasNotifs = Variable(false);

const setTime = (time: number): string => GLib.DateTime
    .new_from_unix_local(time)
    .format('%H:%M') ?? '';

const NotifIcon = ({ notifObj }: {
    notifObj: AstalNotifd.Notification
}) => {
    let icon: string | undefined;

    if (notifObj.get_image() && notifObj.get_image() !== '') {
        icon = notifObj.get_image();
        App.add_icons(icon);
    }
    else if (notifObj.get_app_icon() !== '' && Widget.Icon.lookup_icon(notifObj.get_app_icon())) {
        icon = notifObj.get_app_icon();
    }
    else {
        icon = Applications.fuzzy_query(
            notifObj.get_app_name(),
        )[0]?.get_icon_name();
    }

    return (
        <box
            valign={Gtk.Align.CENTER}
            className="icon"
            css={`
                min-width: 78px;
                min-height: 78px;
            `}
        >
            {icon && (
                <icon
                    icon={icon}
                    css="font-size: 58px;"
                    halign={Gtk.Align.CENTER}
                    hexpand
                    valign={Gtk.Align.CENTER}
                    vexpand
                />
            )}
        </box>
    );
};

const setupButton = (self: Gtk.Widget) => {
    const display = Gdk.Display.get_default();

    // OnHover
    self.connect('enter-notify-event', () => {
        if (!display) {
            return;
        }
        self.window.set_cursor(Gdk.Cursor.new_from_name(
            display,
            'pointer',
        ));
    });

    // OnHoverLost
    self.connect('leave-notify-event', () => {
        if (!display) {
            return;
        }
        self.window.set_cursor(null);
    });
};

const BlockedApps = [
    'Spotify',
];

export const Notification = ({
    id = 0,
    popup_timer = 0,
    slide_in_from = 'Left' as 'Left' | 'Right',
}): NotifGestureWrapper | undefined => {
    const notifications = AstalNotifd.get_default();

    const notifObj = notifications.get_notification(id);

    if (!notifObj) {
        return;
    }

    if (BlockedApps.find((app) => app === notifObj.app_name)) {
        notifObj.dismiss();

        return;
    }

    HasNotifs.set(notifications.get_notifications().length > 0);

    // const progress = SmoothProgress({ className: 'smooth-progress' });

    return (
        <NotifGestureWrapper
            id={id}
            popup_timer={popup_timer}
            slide_in_from={slide_in_from}
            /* setup_notif={(self) => {
                if (self.is_popup) {
                    self.connect('notify::popup-timer', () => {
                        progress.fraction = self.popup_timer / 5;
                    });
                }
                else {
                    progress.destroy();
                }
            }}*/
        >
            <box vertical className={`notification ${notifObj.urgency} widget`}>
                {/* Content */}
                <box>
                    <NotifIcon notifObj={notifObj} />

                    {/* Top of Content */}
                    <box vertical css="min-width: 400px">

                        <box>
                            {/* Title */}
                            <label
                                className="title"
                                halign={Gtk.Align.START}
                                valign={Gtk.Align.END}
                                xalign={0}
                                hexpand
                                max_width_chars={24}
                                truncate
                                wrap
                                label={notifObj.summary}
                                use_markup={notifObj.summary.startsWith('<')}
                            />

                            {/* Time */}
                            <label
                                className="time"
                                valign={Gtk.Align.CENTER}
                                halign={Gtk.Align.END}
                                label={setTime(notifObj.time)}
                            />

                            {/* Close button */}
                            <button
                                className="close-button"
                                valign={Gtk.Align.START}
                                halign={Gtk.Align.END}
                                setup={setupButton}

                                onButtonReleaseEvent={() => {
                                    notifObj.dismiss();
                                }}
                            >
                                <icon icon="window-close-symbolic" />
                            </button>

                        </box>

                        {/* Description */}
                        <label
                            className="description"
                            hexpand
                            use_markup
                            xalign={0}
                            label={notifObj.body}
                            wrap
                        />
                    </box>
                </box>

                {/* progress */}

                {/* Actions */}
                <box className="actions">
                    {notifObj.get_actions().map((action) => (
                        <button
                            className="action-button"
                            hexpand
                            setup={setupButton}

                            onButtonReleaseEvent={() => notifObj.invoke(action.id)}
                        >
                            <label label={action.label} />
                        </button>
                    ))}
                </box>
            </box>
        </NotifGestureWrapper>
    ) as NotifGestureWrapper;
};

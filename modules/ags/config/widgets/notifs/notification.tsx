import { Astal, Gtk } from 'ags/gtk3';
import app from 'ags/gtk3/app';
import AstalApps from 'gi://AstalApps';
import GLib from 'gi://GLib';
const Applications = AstalApps.Apps.new();

import AstalNotifd from 'gi://AstalNotifd';
import { createRoot, createState } from 'gnim';

import NotifGestureWrapper from './gesture';

// Make a variable to connect to for Widgets
// to know when there are notifs or not
export const [HasNotifs, setHasNotifs] = createState(false);

const setTime = (time: number): string =>
    GLib.DateTime.new_from_unix_local(time).format('%H:%M') ?? '';

const NotifIcon = ({ notifObj }: { notifObj: AstalNotifd.Notification }) => {
    let icon: string | undefined;

    if (notifObj.get_image() && notifObj.get_image() !== '') {
        icon = notifObj.get_image();
        app.add_icons(icon);
    }
    else if (
        notifObj.get_app_icon() !== '' &&
        Astal.Icon.lookup_icon(notifObj.get_app_icon())
    ) {
        icon = notifObj.get_app_icon();
    }
    else {
        icon = Applications.fuzzy_query(
            notifObj.get_app_name(),
        )[0]?.get_icon_name();
    }

    return (
        <cursor-button
            cursor="pointer"
            valign={Gtk.Align.CENTER}
            class="icon"
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
        </cursor-button>
    );
};

const BlockedApps = ['Spotify'];

export const Notification = ({
    id = 0,
    popup_timer = 0,
    slide_in_from = 'Left' as 'Left' | 'Right',
}): NotifGestureWrapper | undefined => {
    return createRoot((dispose) => {
        const notifications = AstalNotifd.get_default();

        const notifObj = notifications.get_notification(id);

        if (!notifObj) {
            return;
        }

        if (BlockedApps.find((app) => app === notifObj.app_name)) {
            notifObj.dismiss();

            return;
        }

        setHasNotifs(notifications.get_notifications().length > 0);

        return new NotifGestureWrapper({
            id,
            popup_timer,
            slide_in_from,
            disposeCallback: dispose,
            children: [
                <box
                    vertical
                    class={`notification ${notifObj.get_urgency()} widget`}
                >
                    {/* Content */}
                    <box>
                        <NotifIcon notifObj={notifObj} />

                        {/* Top of Content */}
                        <box vertical css="min-width: 400px">
                            <box>
                                {/* Title */}
                                <label
                                    class="title"
                                    halign={Gtk.Align.START}
                                    valign={Gtk.Align.END}
                                    xalign={0}
                                    hexpand
                                    max_width_chars={24}
                                    truncate
                                    wrap
                                    label={notifObj.get_summary()}
                                    use_markup={notifObj
                                        .get_summary()
                                        .startsWith('<')}
                                />

                                {/* Time */}
                                <label
                                    class="time"
                                    valign={Gtk.Align.CENTER}
                                    halign={Gtk.Align.END}
                                    label={setTime(notifObj.get_time())}
                                />

                                {/* Close button */}
                                <cursor-button
                                    cursor="pointer"
                                    class="close-button"
                                    valign={Gtk.Align.START}
                                    halign={Gtk.Align.END}
                                    onButtonReleaseEvent={() => {
                                        notifObj.dismiss();
                                    }}
                                >
                                    <icon icon="window-close-symbolic" />
                                </cursor-button>
                            </box>

                            {/* Description */}
                            <label
                                class="description"
                                hexpand
                                use_markup
                                xalign={0}
                                label={notifObj.get_body()}
                                wrap
                            />
                        </box>
                    </box>

                    {/* progress */}

                    {/* Actions */}
                    <box class="actions">
                        {notifObj.get_actions().map((action) => (
                            <cursor-button
                                cursor="pointer"
                                class="action-button"
                                hexpand
                                onButtonReleaseEvent={() =>
                                    notifObj.invoke(action.id)
                                }
                            >
                                <label label={action.label} />
                            </cursor-button>
                        ))}
                    </box>
                </box>,
            ],
        });
    });
};

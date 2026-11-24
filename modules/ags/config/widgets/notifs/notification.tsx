import { Gdk, Gtk } from 'ags/gtk4';
import AstalApps from 'gi://AstalApps';
import AstalNotifd from 'gi://AstalNotifd';
import GLib from 'gi://GLib';
import Pango from 'gi://Pango';
import { createRoot, createState } from 'gnim';

import { pointer } from '../../lib/widgets';
import NotifGestureWrapper from './gesture';

const Applications = AstalApps.Apps.new();

// Make a variable to connect to for Widgets
// to know when there are notifs or not
export const [HasNotifs, setHasNotifs] = createState(false);

const setTime = (time: number): string =>
    GLib.DateTime.new_from_unix_local(time).format('%H:%M') ?? '';

const hasIcon = (name: string) => {
    const display = Gdk.Display.get_default();

    return display
        ? Gtk.IconTheme.get_for_display(display).has_icon(name)
        : false;
};

const NotifIcon = ({ notifObj }: { notifObj: AstalNotifd.Notification }) => {
    let file: string | undefined;
    let iconName: string | undefined;

    const image = notifObj.get_image();
    const appIcon = notifObj.get_app_icon();

    if (image && image !== '') {
        if (GLib.file_test(image, GLib.FileTest.EXISTS)) {
            file = image;
        }
        else {
            iconName = image;
        }
    }
    else if (appIcon && appIcon !== '' && hasIcon(appIcon)) {
        iconName = appIcon;
    }
    else {
        iconName = Applications.fuzzy_query(
            notifObj.get_app_name(),
        )[0]?.get_icon_name();
    }

    return (
        <button
            cursor={pointer}
            valign={Gtk.Align.CENTER}
            class="icon"
            css={`
                min-width: 78px;
                min-height: 78px;
            `}
        >
            {(file || iconName) && (
                <image
                    {...(file ? { file } : { iconName })}
                    pixelSize={58}
                    halign={Gtk.Align.CENTER}
                    hexpand
                    valign={Gtk.Align.CENTER}
                    vexpand
                />
            )}
        </button>
    );
};

const BlockedApps = ['Spotify'];

export const Notification = ({
    id = 0,
    popup_timer = 0,
    slide_in_from = 'Left' as 'Left' | 'Right',
}): NotifGestureWrapper | undefined =>
    createRoot((dispose) => {
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

        const summary = notifObj.get_summary() ?? '';

        return new NotifGestureWrapper({
            id,
            popup_timer,
            slide_in_from,
            dispose_callback: dispose,
            children: [
                (
                    <box
                        orientation={Gtk.Orientation.VERTICAL}
                        class={`notification ${notifObj.get_urgency()} widget`}
                    >
                        {/* Content */}
                        <box>
                            <NotifIcon notifObj={notifObj} />

                            {/* Top of Content */}
                            <box
                                orientation={Gtk.Orientation.VERTICAL}
                                css="min-width: 400px;"
                            >
                                <box>
                                    {/* Title */}
                                    <label
                                        class="title"
                                        halign={Gtk.Align.START}
                                        valign={Gtk.Align.END}
                                        xalign={0}
                                        hexpand
                                        maxWidthChars={24}
                                        ellipsize={Pango.EllipsizeMode.END}
                                        wrap
                                        label={summary}
                                        useMarkup={summary.startsWith('<')}
                                    />

                                    {/* Time */}
                                    <label
                                        class="time"
                                        valign={Gtk.Align.CENTER}
                                        halign={Gtk.Align.END}
                                        label={setTime(notifObj.get_time())}
                                    />

                                    {/* Close button */}
                                    <button
                                        cursor={pointer}
                                        class="close-button"
                                        valign={Gtk.Align.START}
                                        halign={Gtk.Align.END}
                                        onClicked={() => {
                                            notifObj.dismiss();
                                        }}
                                    >
                                        <image iconName="window-close-symbolic" />
                                    </button>
                                </box>

                                {/* Description */}
                                <label
                                    class="description"
                                    hexpand
                                    useMarkup
                                    xalign={0}
                                    label={notifObj.get_body() ?? ''}
                                    wrap
                                    wrapMode={Pango.WrapMode.WORD_CHAR}
                                    // GTK4 wrapping labels ask for the width
                                    // of their whole text, so let the box's
                                    // min-width decide where it wraps instead
                                    maxWidthChars={1}
                                />
                            </box>
                        </box>

                        {/* progress */}

                        {/* Actions */}
                        <box class="actions">
                            {notifObj.get_actions().map((action) => (
                                <button
                                    cursor={pointer}
                                    class="action-button"
                                    hexpand
                                    onClicked={() => notifObj.invoke(action.id)}
                                >
                                    <label label={action.label} />
                                </button>
                            ))}
                        </box>
                    </box>
                ) as Gtk.Widget,
            ],
        });
    });

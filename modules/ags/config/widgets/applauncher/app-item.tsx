import { Gtk } from 'ags/gtk4';
import AstalApps from 'gi://AstalApps';
import Pango from 'gi://Pango';

export default ({ app }: { app: AstalApps.Application }) => (
    <box class="app" hexpand>
        <image
            iconName={app.get_icon_name() ?? ''}
            pixelSize={42}
            css="margin-right: 25px;"
        />

        <box orientation={Gtk.Orientation.VERTICAL} valign={Gtk.Align.CENTER}>
            <label
                class="title"
                label={app.get_name()}
                xalign={0}
                ellipsize={Pango.EllipsizeMode.END}
                valign={Gtk.Align.CENTER}
            />

            {app.get_description() !== '' && (
                <label
                    class="description"
                    label={app.get_description()}
                    wrap
                    xalign={0}
                    justify={Gtk.Justification.LEFT}
                    valign={Gtk.Align.CENTER}
                />
            )}
        </box>
    </box>
);

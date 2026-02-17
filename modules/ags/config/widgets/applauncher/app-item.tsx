import { register } from 'ags/gobject';
import { Astal, Gtk } from 'ags/gtk3';
import AstalApps from 'gi://AstalApps';
type AppItemProps = Partial<Astal.Box.ConstructorProps> & {
    app: AstalApps.Application;
    class?: string;
};

@register()
export class AppItem extends Astal.Box {
    readonly app: AstalApps.Application =
        null as unknown as AstalApps.Application;

    constructor({ app, hexpand = true, ...rest }: AppItemProps) {
        super({
            ...rest,
            hexpand,
        });
        this.app = app;

        const icon = (
            <icon
                icon={this.app.get_icon_name()}
                css="font-size: 42px; margin-right: 25px;"
            />
        ) as Astal.Icon;

        const textBox = (
            <box vertical>
                <label
                    class="title"
                    label={app.get_name()}
                    xalign={0}
                    truncate
                    valign={Gtk.Align.CENTER}
                />

                {app.description !== '' && (
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
        ) as Astal.Box;

        this.add(icon);
        this.add(textBox);
    }
}

export default AppItem;

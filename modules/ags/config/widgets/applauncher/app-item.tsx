import { Gtk, Widget } from 'astal/gtk3';
import { register } from 'astal/gobject';

/* Types */
import AstalApps from 'gi://AstalApps';
type AppItemProps = Widget.BoxProps & {
    app: AstalApps.Application
};


@register()
export class AppItem extends Widget.Box {
    readonly app: AstalApps.Application;

    constructor({
        app,
        hexpand = true,
        className = '',
        ...rest
    }: AppItemProps) {
        super({
            ...rest,
            className: `app ${className}`,
            hexpand,
        });
        this.app = app;

        const icon = (
            <icon
                icon={this.app.iconName}
                css="font-size: 42px; margin-right: 25px;"
            />
        );

        const textBox = (
            <box vertical>
                <label
                    className="title"
                    label={app.name}
                    xalign={0}
                    truncate
                    valign={Gtk.Align.CENTER}
                />

                {app.description !== '' && (
                    <label
                        className="description"
                        label={app.description}
                        wrap
                        xalign={0}
                        justify={Gtk.Justification.LEFT}
                        valign={Gtk.Align.CENTER}
                    />
                )}
            </box>
        );

        this.add(icon);
        this.add(textBox);
    }
}

export default AppItem;

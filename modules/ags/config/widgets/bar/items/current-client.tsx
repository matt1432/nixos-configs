import { bind, Variable } from 'astal';
import { Gtk } from 'astal/gtk3';

import AstalApps from 'gi://AstalApps';
import AstalHyprland from 'gi://AstalHyprland';

import Separator from '../../misc/separator';


export default () => {
    const applications = AstalApps.Apps.new();
    const hyprland = AstalHyprland.get_default();

    const visibleIcon = Variable<boolean>(false);
    const focusedIcon = Variable<string>('');
    const focusedTitle = Variable<string>('');

    let lastFocusedAddress: string | null;


    const updateVars = (
        client: AstalHyprland.Client | null = hyprland.get_focused_client(),
    ) => {
        lastFocusedAddress = client ? client.get_address() : null;

        const app = applications.fuzzy_query(
            client?.get_class() ?? '',
        )[0];

        const icon = app?.get_icon_name();

        if (icon) {
            visibleIcon.set(true);
            focusedIcon.set(icon);
        }
        else {
            visibleIcon.set(false);
        }

        focusedTitle.set(client?.get_title() ?? '');
        const id = client?.connect('notify::title', (c) => {
            if (c.get_address() !== lastFocusedAddress) {
                c.disconnect(id);
            }
            else {
                focusedTitle.set(c.get_title());
            }
        });
    };

    updateVars();
    hyprland.connect('notify::focused-client', () => updateVars());

    return (
        <revealer
            transitionType={Gtk.RevealerTransitionType.SLIDE_RIGHT}
            revealChild={bind(focusedTitle).as((title) => title !== '')}
        >
            <box>
                <Separator size={8} />

                <box className="bar-item current-window">
                    <revealer
                        transitionType={Gtk.RevealerTransitionType.SLIDE_RIGHT}
                        revealChild={bind(visibleIcon)}
                    >
                        <box>
                            <icon
                                css="font-size: 32px;"
                                icon={bind(focusedIcon)}
                            />

                            <Separator size={8} />
                        </box>
                    </revealer>

                    <label
                        label={bind(focusedTitle)}
                        truncate
                        maxWidthChars={35}
                    />
                </box>
            </box>
        </revealer>
    );
};

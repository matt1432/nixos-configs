import { bind, Variable } from 'astal';
import { Gtk } from 'astal/gtk3';

import AstalApps from 'gi://AstalApps';
import AstalHyprland from 'gi://AstalHyprland';

import Separator from '../../misc/separator';

import { hyprMessage } from '../../../lib';


export default () => {
    const applications = AstalApps.Apps.new();
    const hyprland = AstalHyprland.get_default();

    const visibleIcon = Variable<boolean>(false);
    const focusedIcon = Variable<string>('');

    // FIXME: readd this once client titles are fixed
    // let lastFocusedAddress: string | null;


    const updateVars = (
        client: AstalHyprland.Client | null = hyprland.get_focused_client(),
    ) => {
        // lastFocusedAddress = client ? client.address : null;

        const app = applications.fuzzy_query(
            client?.class ?? '',
        )[0];

        const icon = app?.iconName;

        if (icon) {
            visibleIcon.set(true);
            focusedIcon.set(icon);
        }
        else {
            visibleIcon.set(false);
        }
    };

    updateVars();
    // hyprland.connect('notify::focused-client', () => updateVars());
    hyprland.connect('event', async() => {
        try {
            updateVars(JSON.parse(await hyprMessage('j/activewindow')));
        }
        catch (e) {
            console.log(e);
        }
    });

    return (
        <revealer
            transitionType={Gtk.RevealerTransitionType.SLIDE_RIGHT}
            revealChild={bind(visibleIcon)}
        >
            <box>
                <box className="bar-item current-window">
                    <icon
                        css="font-size: 32px;"
                        icon={bind(focusedIcon)}
                    />
                </box>

                <Separator size={8} />
            </box>
        </revealer>
    );
};

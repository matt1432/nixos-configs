import { bind, Variable } from 'astal';

import AstalApps from 'gi://AstalApps';
import AstalHyprland from 'gi://AstalHyprland';

import { hyprMessage } from '../../../lib';


export default () => {
    const applications = AstalApps.Apps.new();
    const hyprland = AstalHyprland.get_default();

    const visibleIcon = Variable<boolean>(false);
    const focusedIcon = Variable<string>('');

    let lastFocused: string | undefined;

    const updateVars = (
        client: AstalHyprland.Client | null = hyprland.get_focused_client(),
    ) => {
        lastFocused = client?.get_address();
        const app = applications.fuzzy_query(
            client?.get_class() ?? '',
        )[0];

        const icon = app?.iconName;

        if (icon) {
            visibleIcon.set(true);
            focusedIcon.set(icon);
        }
        else {
            visibleIcon.set(false);
        }

        const id = client?.connect('notify::title', (c) => {
            if (c.get_address() !== lastFocused) {
                c.disconnect(id);
            }
        });
    };

    updateVars();
    hyprland.connect('notify::focused-client', () => updateVars());
    hyprland.connect('client-removed', () => updateVars());
    hyprland.connect('client-added', async() => {
        try {
            updateVars(hyprland.get_client(JSON.parse(await hyprMessage('j/activewindow')).address));
        }
        catch (e) {
            console.log(e);
        }
    });

    return (
        <box
            className="bar-item current-window"
            visible={bind(visibleIcon)}
        >
            <icon
                css="font-size: 32px;"
                icon={bind(focusedIcon)}
            />
        </box>
    );
};

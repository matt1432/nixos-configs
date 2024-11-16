import { bind, Variable } from 'astal';

import AstalApps from 'gi://AstalApps';
const Applications = AstalApps.Apps.new();

import AstalHyprland from 'gi://AstalHyprland';
const Hyprland = AstalHyprland.get_default();

import { hyprMessage } from '../../../lib';


export default () => {
    const visibleIcon = Variable<boolean>(false);
    const focusedIcon = Variable<string>('');

    let lastFocused: string | undefined;

    const updateVars = (
        client: AstalHyprland.Client | null = Hyprland.get_focused_client(),
    ) => {
        lastFocused = client?.get_address();
        const app = Applications.fuzzy_query(
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
    Hyprland.connect('notify::focused-client', () => updateVars());
    Hyprland.connect('client-removed', () => updateVars());
    Hyprland.connect('client-added', async() => {
        try {
            updateVars(Hyprland.get_client(JSON.parse(await hyprMessage('j/activewindow')).address));
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

import { bind, Variable } from 'astal';

import AstalApps from 'gi://AstalApps?version=0.1';
const Applications = AstalApps.Apps.new();

import AstalHyprland from 'gi://AstalHyprland?version=0.1';
const Hyprland = AstalHyprland.get_default();

import Separator from '../../misc/separator';


export default () => {
    const focusedIcon = Variable<string>('');
    const focusedTitle = Variable<string>('');

    let lastFocused: string | undefined;

    const updateVars = (
        client: AstalHyprland.Client | null | undefined = Hyprland.get_focused_client(),
    ) => {
        lastFocused = client?.get_address();
        const app = Applications.query(
            client?.get_class() ?? '',
            false,
        )[0];

        focusedIcon.set(app.iconName ?? '');
        focusedTitle.set(client?.get_title() ?? '');
        const id = client?.connect('notify::title', (c) => {
            if (c.get_address() !== lastFocused) {
                c.disconnect(id);
            }
            focusedTitle.set(c.get_title());
        });
    };

    updateVars();
    Hyprland.connect('notify::focused-client', () => updateVars());
    Hyprland.connect('client-removed', () => updateVars());
    Hyprland.connect('client-added', () => {
        updateVars(Hyprland.get_client(JSON.parse(Hyprland.message('j/activewindow')).address));
    });

    return (
        <box
            className="bar-item current-window"
            visible={bind(focusedTitle).as((title) => title !== '')}
        >
            <icon
                css="font-size: 32px;"
                icon={bind(focusedIcon)}
            />

            <Separator size={8} />

            <label
                label={bind(focusedTitle)}
                truncate
            />
        </box>
    );
};

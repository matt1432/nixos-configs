import { bind } from 'astal';

import AstalApps from 'gi://AstalApps?version=0.1';
const Applications = AstalApps.Apps.new();

import AstalHyprland from 'gi://AstalHyprland?version=0.1';
const Hyprland = AstalHyprland.get_default();

import Separator from '../../misc/separator';


export default () => {
    const focused = bind(Hyprland, 'focusedClient');

    return (
        <box
            className="bar-item current-window"
            visible={focused.as(Boolean)}
        >
            <icon
                css="font-size: 32px;"
                setup={(self) => {
                    self.hook(Hyprland, 'notify::focused-client', () => {
                        const app = Applications.query(
                            Hyprland.get_focused_client()?.get_class() ?? '',
                            false,
                        )[0];

                        self.set_icon(app.iconName ?? '');
                    });
                }}
            />

            <Separator size={8} />

            {focused.as((client) => (client && (
                <label
                    label={bind(client, 'title').as(String)}
                    truncate
                />
            )))}
        </box>
    );
};

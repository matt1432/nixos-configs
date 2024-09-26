import { Variable } from 'astal';
import AstalHyprland from 'gi://AstalHyprland?version=0.1';

const Hyprland = AstalHyprland.get_default();

import { get_monitor_desc } from '../../lib';


const FullscreenState = Variable({
    monitors: [] as string[],
    clientAddrs: new Map() as Map<string, string>,
});

Hyprland.connect('event', () => {
    const arrayEquals = (a1: unknown[], a2: unknown[]) =>
        a1.sort().toString() === a2.sort().toString();

    const mapEquals = (m1: Map<string, string>, m2: Map<string, string>) =>
        m1.size === m2.size &&
        Array.from(m1.keys()).every((key) => m1.get(key) === m2.get(key));

    const fs = FullscreenState.get();
    const fsClients = Hyprland.get_clients().filter((c) => {
        const mon = c.get_monitor();

        return c.fullscreen &&
          c.workspace.id === mon?.activeWorkspace.id;
    });

    const monitors = fsClients.map((c) =>
        get_monitor_desc(c.monitor));

    const clientAddrs = new Map(fsClients.map((c) => [
        get_monitor_desc(c.monitor),
        c.address ?? '',
    ]));

    const hasChanged =
        !arrayEquals(monitors, fs.monitors) ||
        !mapEquals(clientAddrs, fs.clientAddrs);

    if (hasChanged) {
        FullscreenState.set({
            monitors,
            clientAddrs,
        });
    }
});

export default FullscreenState;

import { Gdk } from 'astal';
import AstalHyprland from 'gi://AstalHyprland?version=0.1';

const Hyprland = AstalHyprland.get_default();


export const get_hyprland_monitor = (monitor: Gdk.Monitor): AstalHyprland.Monitor | undefined => {
    const manufacturer = monitor.manufacturer?.replace(',', '');
    const model = monitor.model?.replace(',', '');
    const start = `${manufacturer} ${model}`;

    return Hyprland.get_monitors().find((m) => m.description?.startsWith(start));
};

export const get_hyprland_monitor_desc = (monitor: Gdk.Monitor): string => {
    const manufacturer = monitor.manufacturer?.replace(',', '');
    const model = monitor.model?.replace(',', '');
    const start = `${manufacturer} ${model}`;

    return `desc:${Hyprland.get_monitors().find((m) => m.description?.startsWith(start))?.description}`;
};

export const get_gdkmonitor_from_desc = (desc: string): Gdk.Monitor => {
    const display = Gdk.Display.get_default();

    for (let m = 0; m < (display?.get_n_monitors() ?? 0); m++) {
        const monitor = display?.get_monitor(m);

        if (monitor && desc === get_hyprland_monitor_desc(monitor)) {
            return monitor;
        }
    }

    throw Error(`Monitor ${desc} not found`);
};

export const get_monitor_desc = (mon: AstalHyprland.Monitor): string => {
    return `desc:${mon.description}`;
};

const Hyprland = await Service.import('hyprland');

import Gdk from 'gi://Gdk?version=3.0';

/* Types */
import { Monitor } from 'types/service/hyprland';


export const get_hyprland_monitor = (monitor: Gdk.Monitor): Monitor | undefined => {
    const manufacturer = monitor.manufacturer?.replace(',', '');
    const model = monitor.model?.replace(',', '');
    const start = `${manufacturer} ${model}`;

    return Hyprland.monitors.find((m) => m.description.startsWith(start));
};

export const get_hyprland_monitor_desc = (monitor: Gdk.Monitor): string => {
    const manufacturer = monitor.manufacturer?.replace(',', '');
    const model = monitor.model?.replace(',', '');
    const start = `${manufacturer} ${model}`;

    return `desc:${Hyprland.monitors.find((m) => m.description.startsWith(start))?.description}`;
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

export const get_monitor_desc_from_id = (id: number): string => {
    const monitor = Hyprland.monitors.find((m) => m.id === id);

    return `desc:${monitor?.description}`;
};

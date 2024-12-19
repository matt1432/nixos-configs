import { Gdk } from 'astal/gtk3';

import AstalHyprland from 'gi://AstalHyprland';


export const get_hyprland_monitor = (monitor: Gdk.Monitor): AstalHyprland.Monitor | undefined => {
    const hyprland = AstalHyprland.get_default();

    const manufacturer = monitor.manufacturer?.replace(',', '');
    const model = monitor.model?.replace(',', '');
    const start = `${manufacturer} ${model}`;

    return hyprland.get_monitors().find((m) => m.description?.startsWith(start));
};

export const get_hyprland_monitor_desc = (monitor: Gdk.Monitor): string => {
    const hyprland = AstalHyprland.get_default();

    const manufacturer = monitor.manufacturer?.replace(',', '');
    const model = monitor.model?.replace(',', '');
    const start = `${manufacturer} ${model}`;

    return `desc:${hyprland.get_monitors().find((m) => m.description?.startsWith(start))?.description}`;
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

export const hyprMessage = (message: string) => new Promise<string>((
    resolution = () => { /**/ },
    rejection = () => { /**/ },
) => {
    const hyprland = AstalHyprland.get_default();

    try {
        hyprland.message_async(message, (_, asyncResult) => {
            const result = hyprland.message_finish(asyncResult);

            resolution(result);
        });
    }
    catch (e) {
        rejection(e);
    }
});

export const centerCursor = (): void => {
    const hyprland = AstalHyprland.get_default();

    let x: number;
    let y: number;
    const monitor = hyprland.get_focused_monitor();

    switch (monitor.transform) {
        case 1:
            x = monitor.x - (monitor.height / 2);
            y = monitor.y - (monitor.width / 2);
            break;

        case 2:
            x = monitor.x - (monitor.width / 2);
            y = monitor.y - (monitor.height / 2);
            break;

        case 3:
            x = monitor.x + (monitor.height / 2);
            y = monitor.y + (monitor.width / 2);
            break;

        default:
            x = monitor.x + (monitor.width / 2);
            y = monitor.y + (monitor.height / 2);
            break;
    }

    hyprMessage(`dispatch movecursor ${x} ${y}`);
};

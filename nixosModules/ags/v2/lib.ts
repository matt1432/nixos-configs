import { App, Gdk, Widget } from 'astal/gtk3';

import AstalApps from 'gi://AstalApps';

import AstalHyprland from 'gi://AstalHyprland';
const Hyprland = AstalHyprland.get_default();

/* Types */
export interface Layer {
    address: string
    x: number
    y: number
    w: number
    h: number
    namespace: string
}
export interface Levels {
    0?: Layer[] | null
    1?: Layer[] | null
    2?: Layer[] | null
    3?: Layer[] | null
}
export interface Layers {
    levels: Levels
}
export type LayerResult = Record<string, Layers>;
export interface CursorPos {
    x: number
    y: number
}


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

export const hyprMessage = (message: string) => new Promise<string>((
    resolution = () => { /**/ },
    rejection = () => { /**/ },
) => {
    try {
        Hyprland.message_async(message, (_, asyncResult) => {
            const result = Hyprland.message_finish(asyncResult);

            resolution(result);
        });
    }
    catch (e) {
        rejection(e);
    }
});

export const centerCursor = async(): Promise<void> => {
    let x: number;
    let y: number;
    const monitor = (JSON.parse(await hyprMessage('j/monitors')) as AstalHyprland.Monitor[])
        .find((m) => m.focused) as AstalHyprland.Monitor;

    // @ts-expect-error this should be good
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

    await hyprMessage(`dispatch movecursor ${x} ${y}`);
};

export const get_app_icon = (app: AstalApps.Application): string => {
    if (app.get_icon_name() && Widget.Icon.lookup_icon(app.get_icon_name())) {
        return app.get_icon_name();
    }
    else {
        const iconString = app.get_key('Icon');

        App.add_icons(iconString);

        return iconString;
    }
};

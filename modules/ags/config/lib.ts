import { idle, subprocess } from 'astal';
import { App, Gdk, Gtk } from 'astal/gtk3';

import AstalHyprland from 'gi://AstalHyprland';

/* Types */
import PopupWindow from './widgets/misc/popup-window';

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

type PointProps = [number, number] | {
    x: number
    y: number
} | number;

export class Point {
    public x = 0;
    public y = 0;

    get values(): [number, number] {
        return [this.x, this.y];
    }

    constructor(props?: PointProps, y?: number) {
        if (typeof props === 'number') {
            if (y) {
                this.x = props;
                this.y = y;
            }
            else {
                throw new Error('Wrong props');
            }
        }
        else if (Array.isArray(props)) {
            this.x = props[0];
            this.y = props[1];
        }
        else if (props) {
            this.x = props.x;
            this.y = props.y;
        }
    }
}

export type BezierPoints = [number, number, number, number];

export class Bezier {
    private _points: BezierPoints;

    get points() {
        return [...this._points] as BezierPoints;
    }

    constructor(x1: number, y1: number, x2: number, y2: number) {
        this._points = [x1, y1, x2, y2];
    }
}


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

export const closeAll = () => {
    (App.get_windows() as PopupWindow[])
        .filter((w) => w &&
            w.close_on_unfocus &&
            w.close_on_unfocus !== 'stay')
        .forEach((w) => {
            App.get_window(w.name)?.set_visible(false);
        });
};

export const perMonitor = (window: (monitor: Gdk.Monitor) => Gtk.Widget) => idle(() => {
    const display = Gdk.Display.get_default();
    const windows = new Map<Gdk.Monitor, Gtk.Widget>();

    const createWindow = (monitor: Gdk.Monitor) => {
        windows.set(monitor, window(monitor));
    };

    for (let m = 0; m < (display?.get_n_monitors() ?? 0); m++) {
        const monitor = display?.get_monitor(m);

        if (monitor) {
            createWindow(monitor);
        }
    }

    display?.connect('monitor-added', (_, monitor) => {
        createWindow(monitor);
    });

    display?.connect('monitor-removed', (_, monitor) => {
        windows.get(monitor)?.destroy();
        windows.delete(monitor);
    });
});

interface NotifyAction {
    id: string
    label: string
    callback: () => void
}
interface NotifySendProps {
    actions?: NotifyAction[]
    appName?: string
    body?: string
    category?: string
    hint?: string
    iconName: string
    replaceId?: number
    title: string
    urgency?: 'low' | 'normal' | 'critical'
}

const escapeShellArg = (arg: string): string => `'${arg?.replace(/'/g, '\'\\\'\'')}'`;

export const notifySend = ({
    actions = [],
    appName,
    body,
    category,
    hint,
    iconName,
    replaceId,
    title,
    urgency = 'normal',
}: NotifySendProps) => new Promise<number>((resolve) => {
    let printedId = false;

    const cmd = [
        'notify-send',
        '--print-id',
        `--icon=${escapeShellArg(iconName)}`,
        escapeShellArg(title),
        escapeShellArg(body ?? ''),
        // Optional params
        appName ? `--app-name=${escapeShellArg(appName)}` : '',
        category ? `--category=${escapeShellArg(category)}` : '',
        hint ? `--hint=${escapeShellArg(hint)}` : '',
        replaceId ? `--replace-id=${replaceId.toString()}` : '',
        `--urgency=${urgency}`,
    ].concat(
        actions.map(({ id, label }) => `--action=${escapeShellArg(id)}=${escapeShellArg(label)}`),
    ).join(' ');

    subprocess(
        cmd,
        (out) => {
            if (!printedId) {
                resolve(parseInt(out));
                printedId = true;
            }
            else {
                actions.find((action) => action.id === out)?.callback();
            }
        },
        (err) => {
            console.error(`[Notify] ${err}`);
        },
    );
});

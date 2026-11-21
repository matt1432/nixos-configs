import { Gdk, Gtk } from 'ags/gtk4';
import app from 'ags/gtk4/app';
import { idle } from 'ags/time';

/* Types */
import PopupWindow from '../widgets/misc/popup-window';

export interface Layer {
    address: string;
    x: number;
    y: number;
    w: number;
    h: number;
    namespace: string;
}
export interface Levels {
    0?: Layer[] | null;
    1?: Layer[] | null;
    2?: Layer[] | null;
    3?: Layer[] | null;
}
export interface Layers {
    levels: Levels;
}
export type LayerResult = Record<string, Layers>;
export interface CursorPos {
    x: number;
    y: number;
}

export const getWindow = (name: string): PopupWindow | undefined =>
    (app.get_windows() as unknown as PopupWindow[]).find(
        (w) => name.startsWith(w.name) || w.name.startsWith(name),
    );

export const closeAll = () => {
    (app.get_windows() as unknown as PopupWindow[])
        .filter((w) => w && w.close_on_unfocus && w.close_on_unfocus !== 'stay')
        .forEach((w) => {
            app.get_window(w.name)?.set_visible(false);
        });
};

export const getMonitors = (): Gdk.Monitor[] => {
    const monitors = Gdk.Display.get_default()?.get_monitors();
    const list: Gdk.Monitor[] = [];

    for (let m = 0; m < (monitors?.get_n_items() ?? 0); m++) {
        const monitor = monitors?.get_item(m) as Gdk.Monitor | null;

        if (monitor) {
            list.push(monitor);
        }
    }

    return list;
};

export const perMonitor = (window: (monitor: Gdk.Monitor) => Gtk.Window) =>
    idle(() => {
        const windows = new Map<Gdk.Monitor, Gtk.Window>();

        const sync = () => {
            const monitors = getMonitors();

            monitors.forEach((monitor) => {
                if (!windows.has(monitor)) {
                    windows.set(monitor, window(monitor));
                }
            });

            [...windows.entries()].forEach(([monitor, win]) => {
                if (!monitors.includes(monitor)) {
                    win.destroy();
                    windows.delete(monitor);
                }
            });
        };

        sync();
        Gdk.Display.get_default()
            ?.get_monitors()
            .connect('items-changed', sync);
    });

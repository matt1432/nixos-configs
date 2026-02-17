import { Gdk, Gtk } from 'ags/gtk3';
import app from 'ags/gtk3/app';
import { idle } from 'ags/time';

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

export const getWindow = (name: string): PopupWindow | undefined => {
    return (app.get_windows() as PopupWindow[]).find(
        (w) => name.startsWith(w.name) || w.name.startsWith(name),
    );
};

export const closeAll = () => {
    (app.get_windows() as PopupWindow[])
        .filter((w) => w && w.closeOnUnfocus && w.closeOnUnfocus !== 'stay')
        .forEach((w) => {
            app.get_window(w.name)?.set_visible(false);
        });
};

export const perMonitor = (window: (monitor: Gdk.Monitor) => Gtk.Widget) => {
    return idle(() => {
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
};

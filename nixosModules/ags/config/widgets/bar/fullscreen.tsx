import { App, Astal, Gdk, Gtk, Widget } from 'astal/gtk3';
import { bind, idle, Variable } from 'astal';

import AstalHyprland from 'gi://AstalHyprland';

import { get_hyprland_monitor_desc, get_monitor_desc, hyprMessage } from '../../lib';


const FullscreenState = Variable({
    monitors: [] as string[],
    clientAddrs: new Map() as Map<string, string>,
});

export default ({
    anchor,
    gdkmonitor = Gdk.Display.get_default()?.get_monitor(0) as Gdk.Monitor,
    child,
    ...rest
}: {
    anchor: Astal.WindowAnchor
    gdkmonitor?: Gdk.Monitor
} & Widget.WindowProps) => {
    const hyprland = AstalHyprland.get_default();

    const monitor = get_hyprland_monitor_desc(gdkmonitor);
    const BarVisible = Variable(false);

    hyprland.connect('event', async() => {
        const arrayEquals = (a1: unknown[], a2: unknown[]) =>
            a1.sort().toString() === a2.sort().toString();

        const mapEquals = (m1: Map<string, string>, m2: Map<string, string>) =>
            m1.size === m2.size &&
        Array.from(m1.keys()).every((key) => m1.get(key) === m2.get(key));

        try {
            const newMonitors = JSON.parse(await hyprMessage('j/monitors')) as AstalHyprland.Monitor[];

            const fs = FullscreenState.get();
            const fsClients = hyprland.get_clients().filter((c) => {
                const mon = newMonitors.find((m) => m.id === c.get_monitor()?.id);

                return c.fullscreenClient !== 0 &&
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
        }
        catch (e) {
            console.log(e);
        }
    });

    FullscreenState.subscribe((v) => {
        BarVisible.set(!v.monitors.includes(monitor));
    });

    const barCloser = (
        <window
            name={`noanim-bar-${monitor}-closer`}
            namespace={`noanim-bar-${monitor}-closer`}
            css="all: unset;"
            visible={false}
            gdkmonitor={gdkmonitor}
            layer={Astal.Layer.OVERLAY}
            anchor={
                Astal.WindowAnchor.TOP |
                Astal.WindowAnchor.BOTTOM |
                Astal.WindowAnchor.LEFT |
                Astal.WindowAnchor.RIGHT
            }
        >
            <eventbox
                on_hover={() => {
                    barCloser.visible = false;
                    BarVisible.set(false);
                }}
            >
                <box css="padding: 1px;" />
            </eventbox>
        </window>
    );

    // Hide bar instantly when out of focus
    hyprland.connect('notify::focused-workspace', () => {
        const addr = FullscreenState.get().clientAddrs.get(monitor);

        if (addr) {
            const client = hyprland.get_client(addr);

            if (client?.workspace.id !== hyprland.get_focused_workspace().get_id()) {
                BarVisible.set(true);
                barCloser.visible = false;
            }
            else {
                BarVisible.set(false);
                barCloser.visible = true;
            }
        }
    });

    const buffer = (
        <box
            css="min-height: 10px;"
            visible={bind(BarVisible).as((v) => !v)}
        />
    );

    const vertical = anchor >= (Astal.WindowAnchor.LEFT | Astal.WindowAnchor.RIGHT);
    const isBottomOrLeft = (
        anchor === (Astal.WindowAnchor.LEFT | Astal.WindowAnchor.RIGHT | Astal.WindowAnchor.BOTTOM)
    ) || (
        anchor === (Astal.WindowAnchor.LEFT | Astal.WindowAnchor.TOP | Astal.WindowAnchor.BOTTOM)
    );

    let transition: Gtk.RevealerTransitionType;

    if (vertical) {
        transition = isBottomOrLeft ?
            Gtk.RevealerTransitionType.SLIDE_UP :
            Gtk.RevealerTransitionType.SLIDE_DOWN;
    }
    else {
        transition = isBottomOrLeft ?
            Gtk.RevealerTransitionType.SLIDE_RIGHT :
            Gtk.RevealerTransitionType.SLIDE_LEFT;
    }

    const barWrap = (
        <revealer
            reveal_child={bind(BarVisible)}
            transitionType={transition}
        >
            {child}
        </revealer>
    );

    const win = (
        <window
            name={`noanim-bar-${monitor}`}
            namespace={`noanim-bar-${monitor}`}
            layer={Astal.Layer.OVERLAY}
            gdkmonitor={gdkmonitor}
            anchor={anchor}
            {...rest}
        >
            <eventbox
                onHover={() => {
                    if (!BarVisible.get()) {
                        barCloser.visible = true;
                        BarVisible.set(true);
                    }
                }}
            >
                <box
                    css="min-height: 1px; padding: 1px;"
                    hexpand
                    halign={Gtk.Align.FILL}
                    vertical={vertical}
                >
                    {isBottomOrLeft ?
                        [buffer, barWrap] :
                        [barWrap, buffer]}
                </box>
            </eventbox>
        </window>
    ) as Widget.Window;

    App.add_window(win);

    idle(() => {
        BarVisible.set(true);
    });

    return win;
};

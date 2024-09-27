import { Astal, bind, Gdk, Gtk, Variable, Widget } from 'astal';
import AstalHyprland from 'gi://AstalHyprland?version=0.1';

const Hyprland = AstalHyprland.get_default();

import { get_hyprland_monitor_desc, get_monitor_desc } from '../../lib';


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

        return c.fullscreen && c.workspace.id === mon?.activeWorkspace.id;
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

export default ({
    anchor,
    gdkmonitor = Gdk.Display.get_default()?.get_monitor(0) as Gdk.Monitor,
    child,
    ...rest
}: Widget.WindowProps) => {
    const monitor = get_hyprland_monitor_desc(gdkmonitor);
    const BarVisible = Variable(true);

    FullscreenState.subscribe((v) => {
        BarVisible.set(!v.monitors.includes(monitor));
    });

    const barCloser = (
        <window
            name={`bar-${monitor}-closer`}
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
    Hyprland.connect('notify::focused-workspace', () => {
        const addr = FullscreenState.get().clientAddrs.get(monitor);

        if (addr) {
            const client = Hyprland.get_client(addr);

            if (client?.workspace.id !== Hyprland.get_focused_workspace().get_id()) {
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

    return (
        <window
            name={`bar-${monitor}`}
            layer={Astal.Layer.OVERLAY}
            gdkmonitor={gdkmonitor}
            margins={[-1, -1, -1, -1]}
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
    );
};

const Hyprland = await Service.import('hyprland');
const { Box, EventBox, Revealer, Window } = Widget;

import Gdk from 'gi://Gdk?version=3.0';

import {
    get_hyprland_monitor_desc,
    get_monitor_desc_from_id,
} from '../lib.ts';


const FullscreenState = Variable({
    monitors: [] as string[],
    clientAddrs: new Map() as Map<string, string>,
});

Hyprland.connect('event', (hyprObj) => {
    const arrayEquals = (a1: unknown[], a2: unknown[]) =>
        a1.sort().toString() === a2.sort().toString();

    const mapEquals = (m1: Map<string, string>, m2: Map<string, string>) =>
        m1.size === m2.size &&
        Array.from(m1.keys()).every((key) => m1.get(key) === m2.get(key));

    const fs = FullscreenState.value;
    const fsClients = hyprObj.clients.filter((c) => {
        const mon = Hyprland.getMonitor(c.monitor);

        return c.fullscreen &&
          c.workspace.id === mon?.activeWorkspace.id;
    });

    const monitors = fsClients.map((c) =>
        get_monitor_desc_from_id(c.monitor));

    const clientAddrs = new Map(fsClients.map((c) => [
        get_monitor_desc_from_id(c.monitor),
        c.address,
    ]));

    const hasChanged =
        !arrayEquals(monitors, fs.monitors) ||
        !mapEquals(clientAddrs, fs.clientAddrs);

    if (hasChanged) {
        FullscreenState.setValue({
            monitors,
            clientAddrs,
        });
    }
});

export default ({
    anchor,
    bar,
    gdkmonitor = Gdk.Display.get_default()?.get_monitor(0) as Gdk.Monitor,
    ...rest
}) => {
    const monitor = get_hyprland_monitor_desc(gdkmonitor);
    const BarVisible = Variable(true);

    FullscreenState.connect('changed', (v) => {
        BarVisible.setValue(!v.value.monitors.includes(monitor));
    });

    const barCloser = Window({
        name: `bar-${monitor}-closer`,
        visible: false,
        gdkmonitor,
        anchor: ['top', 'bottom', 'left', 'right'],
        layer: 'overlay',

        child: EventBox({
            on_hover: () => {
                barCloser.set_visible(false);
                BarVisible.setValue(false);
            },

            child: Box({
                css: 'padding: 1px;',
            }),
        }),
    });

    // Hide bar instantly when out of focus
    Hyprland.active.workspace.connect('changed', () => {
        const addr = FullscreenState.value.clientAddrs.get(monitor);

        if (addr) {
            const client = Hyprland.getClient(addr);

            if (client!.workspace.id !== Hyprland.active.workspace.id) {
                BarVisible.setValue(false);
                barCloser.visible = false;
            }
        }
    });

    const buffer = Box({
        css: 'min-height: 10px',
        visible: BarVisible.bind().as((v) => !v),
    });

    const vertical = anchor.includes('left') && anchor.includes('right');
    const isBottomOrLeft = (
        anchor.includes('left') && anchor.includes('right') && anchor.includes('bottom')
    ) || (
        anchor.includes('top') && anchor.includes('bottom') && anchor.includes('left')
    );

    let transition: 'slide_up' | 'slide_down' | 'slide_left' | 'slide_right';

    if (vertical) {
        transition = isBottomOrLeft ? 'slide_up' : 'slide_down';
    }
    else {
        transition = isBottomOrLeft ? 'slide_right' : 'slide_left';
    }

    const barWrap = Revealer({
        reveal_child: BarVisible.bind(),
        transition,
        child: bar,
    });

    return Window({
        name: `bar-${monitor}`,
        layer: 'overlay',
        gdkmonitor,
        margins: [-1, -1, -1, -1],
        anchor,
        ...rest,

        attribute: {
            barCloser,
        },

        child: EventBox({
            child: Box({
                css: 'min-height: 1px; padding: 1px;',
                hexpand: true,
                hpack: 'fill',
                vertical,

                children: isBottomOrLeft ?
                    [buffer, barWrap] :
                    [barWrap, buffer],
            }),
        }).on('enter-notify-event', () => {
            if (!BarVisible.value) {
                barCloser.visible = true;
                BarVisible.setValue(true);
            }
        }),
    });
};

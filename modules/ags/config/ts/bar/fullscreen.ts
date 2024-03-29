const Hyprland = await Service.import('hyprland');
const { Box, EventBox, Revealer, Window } = Widget;


const FullscreenState = Variable({
    monitors: [] as number[],
    clientAddrs: new Map() as Map<number, string>,
});

Hyprland.connect('event', (hyprObj) => {
    const arrayEquals = (a1: unknown[], a2: unknown[]) =>
        a1.sort().toString() === a2.sort().toString();

    const mapEquals = (m1: Map<number, string>, m2: Map<number, string>) =>
        m1.size === m2.size &&
        Array.from(m1.keys()).every((key) => m1.get(key) === m2.get(key));

    const fs = FullscreenState.value;
    const fsClients = hyprObj.clients.filter((c) => {
        const mon = Hyprland.getMonitor(c.monitor);

        return c.fullscreen &&
            c.workspace.id === mon?.activeWorkspace.id;
    });

    const monitors = fsClients.map((c) => c.monitor);
    const clientAddrs = new Map(fsClients.map((c) => [c.monitor, c.address]));

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

export default ({ bar, transition, monitor = 0, ...rest }) => {
    const BarVisible = Variable(true);

    FullscreenState.connect('changed', (v) => {
        BarVisible.setValue(!v.value.monitors.includes(monitor));
    });

    const barCloser = Window({
        name: `bar-${monitor}-closer`,
        visible: false,
        monitor,
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

    const rev = Revealer({
        transition,
        reveal_child: BarVisible.bind(),
        child: bar,
    });

    return Window({
        name: `bar-${monitor}`,
        layer: 'overlay',
        monitor,
        margins: [-1, -1, -1, -1],
        ...rest,

        attribute: {
            barCloser,
        },

        child: EventBox({
            child: Box({
                css: 'min-height: 1px; padding: 1px;',
                hexpand: true,
                hpack: 'fill',
                vertical: transition === 'slide_up' ||
                    transition === 'slide_down',

                children: transition === 'slide_up' ||
                        transition === 'slide_left' ?
                    [buffer, rev] :
                    [rev, buffer],
            }),
        }).on('enter-notify-event', () => {
            if (!BarVisible.value) {
                barCloser.visible = true;
                BarVisible.setValue(true);
            }
        }),
    });
};

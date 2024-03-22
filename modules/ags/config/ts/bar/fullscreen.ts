const Hyprland = await Service.import('hyprland');
const { Box, EventBox, Revealer, Window } = Widget;


const FullscreenState = Variable({
    fullscreen: false,
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
    const fsClients = hyprObj.clients.filter((c) => c.fullscreen);

    const fullscreen = fsClients.length > 0;
    const monitors = fsClients.map((c) => c.monitor);
    const clientAddrs = new Map(fsClients.map((c) => [c.monitor, c.address]));

    const hasChanged = fullscreen !== fs.fullscreen ||
        !arrayEquals(monitors, fs.monitors) ||
        !mapEquals(clientAddrs, fs.clientAddrs);

    if (hasChanged) {
        FullscreenState.setValue({
            fullscreen,
            monitors,
            clientAddrs,
        });
    }
});

export default ({ bar, monitor = 0, ...rest }) => {
    const BarVisible = Variable(true);

    FullscreenState.connect('changed', (v) => {
        BarVisible.setValue(!v.value.monitors.includes(monitor));
    });

    // Hide bar instantly when out of focus
    Hyprland.active.workspace.connect('changed', () => {
        const addr = FullscreenState.value.clientAddrs.get(monitor);

        if (addr) {
            const client = Hyprland.getClient(addr);

            if (client!.workspace.id !== Hyprland.active.workspace.id) {
                BarVisible.setValue(false);
            }
        }
    });

    const barCloser = Window({
        name: `bar-${monitor}-closer`,
        visible: false,
        monitor,
        anchor: ['top', 'bottom', 'left', 'right'],
        layer: 'overlay',

        child: EventBox({
            on_hover: (self) => {
                const parent = self.get_parent();

                parent?.set_visible(false);
                BarVisible.setValue(false);
            },

            child: Box({
                css: 'padding: 1px;',
            }),
        }),
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
                vertical: true,

                children: [
                    Box({
                        css: 'min-height: 10px',
                        visible: BarVisible.bind().as((v) => !v),
                    }),

                    Revealer({
                        transition: 'slide_up',
                        reveal_child: BarVisible.bind(),
                        child: bar,
                    }),
                ],
            }),
        }).on('enter-notify-event', () => {
            if (!BarVisible.value) {
                barCloser.visible = true;
                BarVisible.setValue(true);
            }
        }),
    });
};

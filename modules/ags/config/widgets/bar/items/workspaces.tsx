import { Astal, Gtk } from 'ags/gtk3';
import { timeout, Timer } from 'ags/time';
import AstalHyprland from 'gi://AstalHyprland';
import { createRoot, onCleanup } from 'gnim';
import { register } from 'gnim/gobject';

import { hyprMessage } from '../../../lib';
import { getCssProvider, setCss, toggleClassName } from '../../../lib/widgets';

const URGENT_DURATION = 1000;

// TODO: look into AstalWorkspace
const getCurrentWSID = async () => {
    return JSON.parse(await hyprMessage('j/activeworkspace')).address;
};

@register()
class Workspace extends Gtk.Revealer {
    dispose: (() => void) | undefined = undefined;

    private disposeTimer: Timer | undefined = undefined;

    constructor({
        id = 0,
        transitionDuration = 250,
        ...rest
    }: Partial<Gtk.Revealer.ConstructorProps> & {
        id?: number;
    }) {
        super({
            ...rest,
            name: id.toString(),
            transitionDuration,
            transitionType: Gtk.RevealerTransitionType.SLIDE_RIGHT,
        });

        createRoot((dispose) => {
            this.dispose = dispose;

            const hyprland = AstalHyprland.get_default();

            const content = (
                <box valign={Gtk.Align.CENTER} class="button" />
            ) as Astal.Box;

            const update = async (
                _: Astal.Box,
                client?: AstalHyprland.Client,
            ) => {
                try {
                    const workspace = (
                        JSON.parse(
                            await hyprMessage('j/workspaces'),
                        ) as AstalHyprland.Workspace[]
                    )
                        // @ts-expect-error new workspace API
                        .find((ws) => parseInt(ws.address) === id);
                    // @ts-expect-error new workspace API
                    const occupied = workspace && workspace.windows > 0;

                    toggleClassName(content, 'occupied', occupied!);

                    if (!client) {
                        return;
                    }

                    const isUrgent =
                        client &&
                        parseInt(client.get_workspace().get_name()) === id;

                    if (isUrgent) {
                        toggleClassName(content, 'urgent', true);

                        // Only show for a sec when urgent is current workspace
                        if ((await getCurrentWSID()) === id) {
                            timeout(URGENT_DURATION, () => {
                                toggleClassName(content, 'urgent', false);
                            });
                        }
                    }
                }
                catch (e) {
                    if (!String(e).startsWith('SyntaxError: JSON.parse')) {
                        console.log(e);
                    }
                }
            };

            const conns: number[] = [];

            conns.push(
                hyprland.connect('event', () => update(content)),

                // Deal with urgent windows
                hyprland.connect('urgent', () => update(content)),

                hyprland.connect('notify::focused-workspace', async () => {
                    if ((await getCurrentWSID()) === id) {
                        toggleClassName(content, 'urgent', false);
                    }
                }),
            );

            onCleanup(() => {
                conns.forEach((id) => {
                    hyprland.disconnect(id);
                });
                if (this.disposeTimer) {
                    this.disposeTimer.cancel();
                }
                this.disposeTimer = timeout(transitionDuration + 10, () => {
                    this.destroy();
                });
            });

            this.add(
                (
                    <cursor-eventbox
                        cursor="pointer"
                        tooltip_text={id.toString()}
                        onClickRelease={() => {
                            hyprMessage(
                                `dispatch hl.dsp.focus({workspace="${id}"})`,
                            ).catch(console.log);
                        }}
                        $={() => {
                            update(content);
                        }}
                    >
                        {content}
                    </cursor-eventbox>
                ) as Astal.EventBox,
            );
            this.show_all();
        });
    }
}

export default () => {
    const hyprland = AstalHyprland.get_default();

    const L_PADDING = 2;
    const WS_WIDTH = 30;

    const updateHighlight = async (self: Astal.Box) => {
        const currentId = await getCurrentWSID();

        const indicators = (
            (self.get_parent() as Astal.Overlay).get_child() as Astal.Box
        ).get_children() as Workspace[];

        const currentIndex = indicators.findIndex((w) => w.name === currentId);

        if (currentIndex >= 0) {
            setCss(
                getCssProvider(self),
                `margin-left: ${L_PADDING + currentIndex * WS_WIDTH}px`,
            );
        }
    };

    const highlight = (
        <box
            class="button active"
            valign={Gtk.Align.CENTER}
            halign={Gtk.Align.START}
            $={(self) => {
                hyprland.connect('notify::focused-workspace', () => {
                    updateHighlight(self);
                });
            }}
        />
    ) as Astal.Box;

    let workspaces: Workspace[] = [];

    const init = (self: Astal.Box) => {
        const refresh = () => {
            (self.get_children() as Workspace[]).forEach((rev) => {
                rev.set_reveal_child(false);
            });

            workspaces.forEach((ws) => {
                ws.set_reveal_child(true);
            });
        };

        const updateWorkspaces = async () => {
            (
                JSON.parse(
                    await hyprMessage('j/workspaces'),
                ) as AstalHyprland.Workspace[]
            ).forEach((ws) => {
                const currentWs = (self.get_children() as Workspace[]).find(
                    // @ts-expect-error new workspace API
                    (ch) => ch.name === ws.address,
                );

                // @ts-expect-error new workspace API
                if (!currentWs && parseInt(ws.address) > 0) {
                    self.add(
                        new Workspace({
                            // @ts-expect-error new workspace API
                            id: parseInt(ws.address),
                        }),
                    );
                }
            });

            // Make sure the order is correct
            workspaces.forEach((workspace, i) => {
                (workspace.get_parent() as Astal.Box).reorder_child(
                    workspace,
                    i,
                );
            });
        };

        const updateAll = async () => {
            try {
                const oldWorkspaces = workspaces;

                const hyprWorkspaces = JSON.parse(
                    await hyprMessage('j/workspaces'),
                ) as AstalHyprland.Workspace[];

                workspaces = (self.get_children() as Workspace[])
                    .filter((ch) => {
                        return hyprWorkspaces.find((ws) => {
                            // @ts-expect-error new workspace API
                            return ws.address === ch.name;
                        });
                    })
                    .sort(
                        (a, b) =>
                            parseInt(a.name ?? '0') - parseInt(b.name ?? '0'),
                    );

                oldWorkspaces
                    .filter((ws) => !workspaces.includes(ws))
                    .forEach((ch) => {
                        ch.dispose?.();
                    });

                updateWorkspaces();
                refresh();

                // Make sure the highlight doesn't go too far
                const TEMP_TIMEOUT = 100;

                timeout(TEMP_TIMEOUT, () => updateHighlight(highlight));
            }
            catch (e) {
                if (!String(e).startsWith('SyntaxError: JSON.parse')) {
                    console.log(e);
                }
            }
        };

        updateAll();
        hyprland.connect('event', updateAll);
    };

    return (
        <box class="bar-item">
            <overlay class="workspaces" passThrough overlay={highlight}>
                <box $={init} />
            </overlay>
        </box>
    );
};

import { Gtk } from 'ags/gtk4';
import { timeout, Timer } from 'ags/time';
import AstalHyprland from 'gi://AstalHyprland';
import { createRoot, onCleanup } from 'gnim';
import { register } from 'gnim/gobject';

import { hyprMessage } from '../../../lib';
import {
    getChildren,
    pointer,
    setCss,
    toggleClassName,
} from '../../../lib/widgets';

const URGENT_DURATION = 1000;

// TODO: look into AstalWorkspace
const getCurrentWSID = async (): Promise<number> =>
    // The address is a string, but workspace ids are compared as numbers
    parseInt(JSON.parse(await hyprMessage('j/activeworkspace')).address);

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
                <box
                    valign={Gtk.Align.CENTER}
                    class="button"
                    cursor={pointer}
                    tooltipText={id.toString()}
                >
                    <Gtk.GestureClick
                        onReleased={() => {
                            hyprMessage(
                                `dispatch hl.dsp.focus({workspace="${id}"})`,
                            ).catch(console.log);
                        }}
                    />
                </box>
            ) as Gtk.Box;

            const update = async (client?: AstalHyprland.Client) => {
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
                hyprland.connect('event', () => update()),

                // Deal with urgent windows
                hyprland.connect('urgent', (_, client) => update(client)),

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
                    (this.get_parent() as Gtk.Box | null)?.remove(this);
                });
            });

            this.set_child(content);
            update();
        });
    }
}

export default () => {
    const hyprland = AstalHyprland.get_default();

    const L_PADDING = 2;
    const WS_WIDTH = 30;

    let indicatorBox: Gtk.Box | undefined;

    const updateHighlight = async (self: Gtk.Box) => {
        if (!indicatorBox) {
            return;
        }

        const currentId = await getCurrentWSID();

        const indicators = getChildren(indicatorBox) as Workspace[];

        const currentIndex = indicators.findIndex(
            (w) => w.name === currentId.toString(),
        );

        if (currentIndex >= 0) {
            setCss(
                self,
                `margin-left: ${L_PADDING + currentIndex * WS_WIDTH}px;`,
            );
        }
    };

    const highlight = (
        <box
            class="button active"
            valign={Gtk.Align.CENTER}
            halign={Gtk.Align.START}
            canTarget={false}
            $={(self) => {
                hyprland.connect('notify::focused-workspace', () => {
                    updateHighlight(self);
                });
            }}
        />
    ) as Gtk.Box;

    let workspaces: Workspace[] = [];

    const init = (self: Gtk.Box) => {
        indicatorBox = self;

        const refresh = () => {
            (getChildren(self) as Workspace[]).forEach((rev) => {
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
                const currentWs = (getChildren(self) as Workspace[]).find(
                    // @ts-expect-error new workspace API
                    (ch) => ch.name === ws.address,
                );

                // @ts-expect-error new workspace API
                if (!currentWs && parseInt(ws.address) > 0) {
                    self.append(
                        new Workspace({
                            // @ts-expect-error new workspace API
                            id: parseInt(ws.address),
                        }),
                    );
                }
            });

            // Make sure the order is correct
            workspaces.forEach((workspace, i) => {
                if (workspace.get_parent() === self) {
                    self.reorder_child_after(
                        workspace,
                        i === 0 ? null : workspaces[i - 1],
                    );
                }
            });
        };

        const updateAll = async () => {
            try {
                const oldWorkspaces = workspaces;

                const hyprWorkspaces = JSON.parse(
                    await hyprMessage('j/workspaces'),
                ) as AstalHyprland.Workspace[];

                workspaces = (getChildren(self) as Workspace[])
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
            <overlay
                class="workspaces"
                $={(self) => {
                    self.add_overlay(highlight);
                }}
            >
                <box $={init} />
            </overlay>
        </box>
    );
};

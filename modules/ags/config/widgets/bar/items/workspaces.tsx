import { Astal, Gtk } from 'ags/gtk3';
import { timeout, Timer } from 'ags/time';
import AstalHyprland from 'gi://AstalHyprland';
import { createRoot, onCleanup } from 'gnim';
import { register } from 'gnim/gobject';

import { hyprMessage } from '../../../lib';
import { getCssProvider, setCss, toggleClassName } from '../../../lib/widgets';

const URGENT_DURATION = 1000;

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

            const update = (_: Astal.Box, client?: AstalHyprland.Client) => {
                const workspace = hyprland.get_workspace(id);
                const occupied =
                    workspace && workspace.get_clients().length > 0;

                toggleClassName(content, 'occupied', occupied);

                if (!client) {
                    return;
                }

                const isUrgent =
                    client && client.get_workspace().get_id() === id;

                if (isUrgent) {
                    toggleClassName(content, 'urgent', true);

                    // Only show for a sec when urgent is current workspace
                    if (hyprland.get_focused_workspace().get_id() === id) {
                        timeout(URGENT_DURATION, () => {
                            toggleClassName(content, 'urgent', false);
                        });
                    }
                }
            };

            const conns: number[] = [];

            conns.push(
                hyprland.connect('event', () => update(content)),

                // Deal with urgent windows
                hyprland.connect('urgent', () => update(content)),

                hyprland.connect('notify::focused-workspace', () => {
                    if (hyprland.get_focused_workspace().get_id() === id) {
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
                            hyprMessage(`dispatch workspace ${id}`).catch(
                                console.log,
                            );
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

    const updateHighlight = (self: Astal.Box) => {
        const currentId = hyprland.get_focused_workspace().get_id().toString();

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
                hyprland.connect('notify::focused-workspace', () =>
                    updateHighlight(self),
                );
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

        const updateWorkspaces = () => {
            hyprland.get_workspaces().forEach((ws) => {
                const currentWs = (self.get_children() as Workspace[]).find(
                    (ch) => ch.name === ws.get_id().toString(),
                );

                if (!currentWs && ws.get_id() > 0) {
                    self.add(
                        new Workspace({
                            id: ws.get_id(),
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

        const updateAll = () => {
            const oldWorkspaces = workspaces;

            workspaces = (self.get_children() as Workspace[])
                .filter((ch) => {
                    return hyprland.get_workspaces().find((ws) => {
                        return ws.get_id().toString() === ch.name;
                    });
                })
                .sort(
                    (a, b) => parseInt(a.name ?? '0') - parseInt(b.name ?? '0'),
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

import { Gtk } from 'ags/gtk4';
import { timeout, Timer } from 'ags/time';
import AstalHyprland from 'gi://AstalHyprland';
import AstalWorkspace from 'gi://AstalWorkspace';
import { createRoot, onCleanup } from 'gnim';
import { register } from 'gnim/gobject';

import {
    getChildren,
    pointer,
    setCss,
    toggleClassName,
} from '../../../lib/widgets';

const URGENT_DURATION = 1000;

/*
 * The list of workspaces comes from ext-workspace-v1 (AstalWorkspace).
 * It doesn't know which monitor is focused or how many windows a workspace
 * has, so those still come from AstalHyprland. Urgent does too: Hyprland only
 * sends a workspace's ext-workspace state when it is created or its active
 * state changes, so urgent windows don't show up there until then.
 */

// Only numbered workspaces are shown, special and named ones are skipped
const getNumber = (ws: AstalWorkspace.Workspace): number =>
    Number(ws.get_name());

const isShown = (ws: AstalWorkspace.Workspace): boolean =>
    Number.isInteger(getNumber(ws)) && getNumber(ws) > 0;

const getFocusedName = (): string | undefined =>
    AstalHyprland.get_default().get_focused_workspace()?.get_name();

@register()
class Workspace extends Gtk.Revealer {
    dispose: (() => void) | undefined = undefined;

    private disposeTimer: Timer | undefined = undefined;

    constructor({
        workspace,
        transitionDuration = 250,
        ...rest
    }: Partial<Gtk.Revealer.ConstructorProps> & {
        workspace: AstalWorkspace.Workspace;
    }) {
        super({
            ...rest,
            name: workspace.get_name(),
            transitionDuration,
            transitionType: Gtk.RevealerTransitionType.SLIDE_RIGHT,
        });

        createRoot((dispose) => {
            this.dispose = dispose;

            const hyprland = AstalHyprland.get_default();
            const name = workspace.get_name();

            const content = (
                <box
                    valign={Gtk.Align.CENTER}
                    class="button"
                    cursor={pointer}
                    tooltipText={name}
                >
                    <Gtk.GestureClick onReleased={() => workspace.activate()} />
                </box>
            ) as Gtk.Box;

            const updateOccupied = () => {
                toggleClassName(
                    content,
                    'occupied',
                    (hyprland.get_workspace_by_name(name)?.get_clients()
                        .length ?? 0) > 0,
                );
            };

            const hyprConns = [
                hyprland.connect('event', updateOccupied),

                hyprland.connect('urgent', (_, client) => {
                    if (client.get_workspace()?.get_name() !== name) {
                        return;
                    }

                    toggleClassName(content, 'urgent', true);

                    // Only show for a sec when urgent is current workspace
                    if (getFocusedName() === name) {
                        timeout(URGENT_DURATION, () => {
                            toggleClassName(content, 'urgent', false);
                        });
                    }
                }),

                hyprland.connect('notify::focused-workspace', () => {
                    if (getFocusedName() === name) {
                        toggleClassName(content, 'urgent', false);
                    }
                }),
            ];

            onCleanup(() => {
                hyprConns.forEach((id) => {
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
            updateOccupied();
        });
    }
}

export default () => {
    const hyprland = AstalHyprland.get_default();
    const manager = AstalWorkspace.get_default();

    const L_PADDING = 2;
    const WS_WIDTH = 30;

    let indicatorBox: Gtk.Box | undefined;

    const updateHighlight = (self: Gtk.Box) => {
        if (!indicatorBox) {
            return;
        }

        const currentIndex = (getChildren(indicatorBox) as Workspace[])
            .filter((w) => w.get_reveal_child())
            .findIndex((w) => w.name === getFocusedName());

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

    const init = (self: Gtk.Box) => {
        indicatorBox = self;

        const indicators = new Map<AstalWorkspace.Workspace, Workspace>();

        const update = () => {
            const current = manager
                .get_workspaces()
                .filter(isShown)
                .sort((a, b) => getNumber(a) - getNumber(b));

            // Hide and dispose of removed workspaces
            indicators.forEach((indicator, ws) => {
                if (!current.includes(ws)) {
                    indicator.set_reveal_child(false);
                    indicator.dispose?.();
                    indicators.delete(ws);
                }
            });

            // Add new workspaces and make sure the order is correct
            let previous: Workspace | null = null;

            current.forEach((ws) => {
                let indicator = indicators.get(ws);

                if (!indicator) {
                    indicator = new Workspace({ workspace: ws });
                    indicators.set(ws, indicator);
                    self.append(indicator);
                }

                self.reorder_child_after(indicator, previous);
                indicator.set_reveal_child(true);
                previous = indicator;
            });

            // Make sure the highlight doesn't go too far
            const TEMP_TIMEOUT = 100;

            timeout(TEMP_TIMEOUT, () => updateHighlight(highlight));
        };

        update();
        manager.connect('updated', update);
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

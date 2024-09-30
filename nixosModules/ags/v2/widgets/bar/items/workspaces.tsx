import { Gtk, idle, timeout, Widget } from 'astal';

import AstalHyprland from 'gi://AstalHyprland?version=0.1';
const Hyprland = AstalHyprland.get_default();


const URGENT_DURATION = 1000;

const Workspace = ({ id = 0 }) => (
    <revealer
        name={id.toString()}
        transitionType={Gtk.RevealerTransitionType.SLIDE_RIGHT}
    >
        <eventbox
            cursor="pointer"
            tooltip_text={id.toString()}

            onClickRelease={() => {
                Hyprland.message_async(`dispatch workspace ${id}`, () => { /**/ });
            }}
        >
            <box
                valign={Gtk.Align.CENTER}
                className="button"

                setup={(self) => idle(() => {
                    const update = (
                        _: Widget.Box,
                        addr?: string,
                    ) => {
                        const workspace = Hyprland.get_workspace(id);
                        const occupied = workspace && workspace.get_clients().length > 0;

                        self.toggleClassName('occupied', occupied);

                        if (!addr) {
                            return;
                        }

                        // Deal with urgent windows
                        const client = Hyprland.get_client(addr);
                        const isThisUrgent = client &&
                          client.workspace.id === id;

                        if (isThisUrgent) {
                            self.toggleClassName('urgent', true);

                            // Only show for a sec when urgent is current workspace
                            if (Hyprland.get_focused_workspace().get_id() === id) {
                                timeout(URGENT_DURATION, () => {
                                    self.toggleClassName('urgent', false);
                                });
                            }
                        }
                    };

                    self
                        .hook(Hyprland, 'event', update)

                        // Deal with urgent windows
                        .hook(Hyprland, 'urgent', update)

                        .hook(Hyprland, 'notify::focused-workspace', () => {
                            if (Hyprland.get_focused_workspace().get_id() === id) {
                                self.toggleClassName('urgent', false);
                            }
                        });
                })}
            />
        </eventbox>
    </revealer>
);

export default () => {
    const L_PADDING = 2;
    const WS_WIDTH = 30;

    const updateHighlight = (self: Widget.Box) => {
        const currentId = Hyprland.get_focused_workspace().get_id().toString();

        const indicators = ((self.get_parent() as Widget.Overlay)
            .child as Widget.Box)
            .children as Widget.Revealer[];

        const currentIndex = indicators.findIndex((w) => w.name === currentId);

        if (currentIndex >= 0) {
            self.css = `margin-left: ${L_PADDING + (currentIndex * WS_WIDTH)}px`;
        }
    };

    const highlight = (
        <box
            className="button active"

            valign={Gtk.Align.CENTER}
            halign={Gtk.Align.START}

            setup={(self) => {
                self.hook(Hyprland, 'notify::focused-workspace', updateHighlight);
            }}
        />
    ) as Widget.Box;

    let workspaces: Widget.Revealer[] = [];

    return (
        <box
            className="bar-item"
        >
            <overlay
                className="workspaces"
                passThrough
                overlay={highlight}
            >
                <box
                    setup={(self) => {
                        const refresh = () => {
                            (self.children as Widget.Revealer[]).forEach((rev) => {
                                rev.reveal_child = false;
                            });

                            workspaces.forEach((ws) => {
                                ws.reveal_child = true;
                            });
                        };

                        const updateWorkspaces = () => {
                            Hyprland.get_workspaces().forEach((ws) => {
                                const currentWs = (self.children as Widget.Revealer[])
                                    .find((ch) => ch.name === ws.id.toString());

                                if (!currentWs && ws.id > 0) {
                                    self.add(Workspace({ id: ws.id }));
                                }
                            });

                            // Make sure the order is correct
                            workspaces.forEach((workspace, i) => {
                                (workspace.get_parent() as Widget.Box)
                                    .reorder_child(workspace, i);
                            });
                        };

                        self.hook(Hyprland, 'event', () => {
                            workspaces = (self.children as Widget.Revealer[])
                                .filter((ch) => {
                                    return Hyprland.get_workspaces().find((ws) => {
                                        return ws.id.toString() === ch.name;
                                    });
                                })
                                .sort((a, b) => parseInt(a.name ?? '0') - parseInt(b.name ?? '0'));

                            updateWorkspaces();
                            refresh();

                            // Make sure the highlight doesn't go too far
                            const TEMP_TIMEOUT = 100;

                            timeout(TEMP_TIMEOUT, () => updateHighlight(highlight));
                        });
                    }}
                />
            </overlay>
        </box>
    );
};
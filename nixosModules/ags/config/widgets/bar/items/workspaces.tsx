import { Gtk, Widget } from 'astal/gtk3';
import { timeout } from 'astal';

import AstalHyprland from 'gi://AstalHyprland';

import { hyprMessage } from '../../../lib';


const URGENT_DURATION = 1000;

const Workspace = ({ id = 0 }) => {
    const hyprland = AstalHyprland.get_default();

    return (
        <revealer
            name={id.toString()}
            transitionType={Gtk.RevealerTransitionType.SLIDE_RIGHT}
        >
            <eventbox
                cursor="pointer"
                tooltip_text={id.toString()}

                onClickRelease={() => {
                    hyprMessage(`dispatch workspace ${id}`).catch(console.log);
                }}
            >
                <box
                    valign={Gtk.Align.CENTER}
                    className="button"

                    setup={(self) => {
                        const update = (
                            _: Widget.Box,
                            client?: AstalHyprland.Client,
                        ) => {
                            const workspace = hyprland.get_workspace(id);
                            const occupied = workspace && workspace.get_clients().length > 0;

                            self.toggleClassName('occupied', occupied);

                            if (!client) {
                                return;
                            }

                            const isUrgent = client &&
                          client.get_workspace().get_id() === id;

                            if (isUrgent) {
                                self.toggleClassName('urgent', true);

                            // Only show for a sec when urgent is current workspace
                                if (hyprland.get_focused_workspace().get_id() === id) {
                                    timeout(URGENT_DURATION, () => {
                                        self.toggleClassName('urgent', false);
                                    });
                                }
                            }
                        };

                        update(self);
                        self
                            .hook(hyprland, 'event', () => update(self))

                        // Deal with urgent windows
                            .hook(hyprland, 'urgent', update)

                            .hook(hyprland, 'notify::focused-workspace', () => {
                                if (hyprland.get_focused_workspace().get_id() === id) {
                                    self.toggleClassName('urgent', false);
                                }
                            });
                    }}
                />
            </eventbox>
        </revealer>
    );
};

export default () => {
    const Hyprland = AstalHyprland.get_default();

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

                        const updateAll = () => {
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
                        };

                        updateAll();
                        self.hook(Hyprland, 'event', updateAll);
                    }}
                />
            </overlay>
        </box>
    );
};

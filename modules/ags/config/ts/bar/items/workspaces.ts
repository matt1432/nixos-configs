const Hyprland = await Service.import('hyprland');

const { timeout } = Utils;
const { Box, Overlay, Revealer } = Widget;

import CursorBox from '../../misc/cursorbox.ts';

const URGENT_DURATION = 1000;

// Types
import {
    BoxGeneric,
    EventBoxGeneric,
    OverlayGeneric,
    RevealerGeneric,
    Workspace,
} from 'global-types';


const Workspace = ({ id }: { id: number }) => {
    return Revealer({
        transition: 'slide_right',
        attribute: { id },

        child: CursorBox({
            tooltip_text: `${id}`,

            on_primary_click_release: () => {
                Hyprland.messageAsync(`dispatch workspace ${id}`);
            },

            child: Box({
                vpack: 'center',
                class_name: 'button',

                setup: (self) => {
                    const update = (
                        _: BoxGeneric,
                        addr: string | undefined,
                    ) => {
                        const workspace = Hyprland.getWorkspace(id);
                        const occupied = workspace && workspace.windows > 0;

                        self.toggleClassName('occupied', occupied);

                        if (!addr) {
                            return;
                        }

                        // Deal with urgent windows
                        const client = Hyprland.getClient(addr);
                        const isThisUrgent = client &&
                          client.workspace.id === id;

                        if (isThisUrgent) {
                            self.toggleClassName('urgent', true);

                            // Only show for a sec when urgent is current workspace
                            if (Hyprland.active.workspace.id === id) {
                                timeout(URGENT_DURATION, () => {
                                    self.toggleClassName('urgent', false);
                                });
                            }
                        }
                    };

                    self
                        .hook(Hyprland, update)

                        // Deal with urgent windows
                        .hook(Hyprland, update, 'urgent-window')

                        .hook(Hyprland.active.workspace, () => {
                            if (Hyprland.active.workspace.id === id) {
                                self.toggleClassName('urgent', false);
                            }
                        });
                },
            }),
        }),
    });
};

export default () => {
    const L_PADDING = 16;
    const WS_WIDTH = 30;

    const updateHighlight = (self: BoxGeneric) => {
        const currentId = Hyprland.active.workspace.id;

        const indicators = (((self.get_parent() as OverlayGeneric)
            .child as EventBoxGeneric)
            .child as BoxGeneric)
            .children as Workspace[];

        const currentIndex = indicators
            .findIndex((w) => w.attribute.id === currentId);

        if (currentIndex < 0) {
            return;
        }

        self.setCss(`margin-left: ${L_PADDING + (currentIndex * WS_WIDTH)}px`);
    };

    const highlight = Box({
        vpack: 'center',
        hpack: 'start',
        class_name: 'button active',

    }).hook(Hyprland.active.workspace, updateHighlight);

    const widget = Overlay({
        pass_through: true,
        overlays: [highlight],
        child: CursorBox({
            child: Box({
                class_name: 'workspaces',

                attribute: { workspaces: [] as Workspace[] },

                setup: (self) => {
                    const refresh = () => {
                        (self.children as RevealerGeneric[])
                            .forEach((rev) => {
                                rev.reveal_child = false;
                            });

                        self.attribute.workspaces
                            .forEach((ws) => {
                                ws.reveal_child = true;
                            });
                    };

                    const updateWorkspaces = () => {
                        Hyprland.workspaces.forEach((ws) => {
                            const currentWs =
                                (self.children as Workspace[])
                                    .find((ch) => ch.attribute.id === ws.id);

                            if (!currentWs && ws.id > 0) {
                                self.add(Workspace({ id: ws.id }));
                            }
                        });
                        self.show_all();

                        // Make sure the order is correct
                        self.attribute.workspaces.forEach((workspace, i) => {
                            (workspace.get_parent() as BoxGeneric)
                                .reorder_child(workspace, i);
                        });
                    };

                    self.hook(Hyprland, () => {
                        self.attribute.workspaces =
                            (self.children as Workspace[])
                                .filter((ch) => {
                                    return Hyprland.workspaces.find((ws) => {
                                        return ws.id === ch.attribute.id;
                                    });
                                })
                                .sort((a, b) =>
                                    a.attribute.id - b.attribute.id);

                        updateWorkspaces();
                        refresh();

                        // Make sure the highlight doesn't go too far
                        const TEMP_TIMEOUT = 10;

                        timeout(TEMP_TIMEOUT, () => updateHighlight(highlight));
                    });
                },
            }),
        }),
    });

    return widget;
};

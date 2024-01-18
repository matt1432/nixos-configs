import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

import { timeout } from 'resource:///com/github/Aylur/ags/utils.js';
import { Box, Overlay, Revealer } from 'resource:///com/github/Aylur/ags/widget.js';

import CursorBox from '../../misc/cursorbox.ts';

const URGENT_DURATION = 1000;

// Types
import AgsBox from 'types/widgets/box.ts';
import AgsRevealer from 'types/widgets/revealer.ts';
import AgsOverlay from 'types/widgets/overlay.ts';
import AgsEventBox from 'types/widgets/eventbox.ts';


const Workspace = ({ id }: { id: number }) => {
    return Revealer({
        transition: 'slide_right',
        attribute: { id },

        child: CursorBox({
            tooltip_text: `${id}`,

            on_primary_click_release: () => {
                Hyprland.sendMessage(`dispatch workspace ${id}`);
            },

            child: Box({
                vpack: 'center',
                class_name: 'button',

                setup: (self) => {
                    const update = (_: AgsBox, addr: string | undefined) => {
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

    const updateHighlight = (self: AgsBox) => {
        const currentId = Hyprland.active.workspace.id;

        const indicators = (((self.get_parent() as AgsOverlay)
            .child as AgsEventBox)
            .child as AgsBox)
            .children as Array<AgsRevealer>;

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

                attribute: { workspaces: [] },

                setup: (self) => {
                    const workspaces = (): Array<AgsRevealer> =>
                        self.attribute.workspaces;

                    const refresh = () => {
                        (self.children as Array<AgsRevealer>).forEach((rev) => {
                            rev.reveal_child = false;
                        });

                        workspaces().forEach((ws) => {
                            ws.reveal_child = true;
                        });
                    };

                    const updateWorkspaces = () => {
                        Hyprland.workspaces.forEach((ws) => {
                            const currentWs = (self.children as Array<AgsBox>)
                                .find((ch) => ch.attribute.id === ws.id);

                            if (!currentWs && ws.id > 0) {
                                self.add(Workspace({ id: ws.id }));
                            }
                        });
                        self.show_all();

                        // Make sure the order is correct
                        workspaces().forEach((workspace, i) => {
                            (<AgsBox> workspace.get_parent()).reorder_child(
                                workspace,
                                i,
                            );
                        });
                    };

                    self.hook(Hyprland, () => {
                        self.attribute.workspaces =
                            (self.children as Array<AgsBox>).filter((ch) => {
                                return Hyprland.workspaces.find((ws) => {
                                    return ws.id === ch.attribute.id;
                                });
                            }).sort((a, b) => a.attribute.id - b.attribute.id);

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
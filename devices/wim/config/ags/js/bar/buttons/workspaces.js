import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

import { timeout } from 'resource:///com/github/Aylur/ags/utils.js';
import { Box, Overlay, Revealer } from 'resource:///com/github/Aylur/ags/widget.js';

import CursorBox from '../../misc/cursorbox.js';

const URGENT_DURATION = 1000;

/** @typedef {import('types/widgets/revealer.js').default} Revealer */


/** @property {number} id */
const Workspace = ({ id }) => {
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
                    /**
                     * @param {import('types/widgets/box').default} _
                     * @param {string|undefined} addr
                     */
                    const update = (_, addr) => {
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

    /** @param {import('types/widgets/box').default} self */
    const updateHighlight = (self) => {
        const currentId = Hyprland.active.workspace.id;

        /** @type Array<Revealer> */
        // @ts-expect-error
        const indicators = self?.get_parent()?.child.child.child.children;

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

                attribute: {
                    /** @type Array<Revealer> */
                    workspaces: [],
                },

                setup: (self) => {
                    /** @type function(void):Array<Revealer> */
                    const workspaces = () => self.attribute.workspaces;

                    const refresh = () => {
                        self.children.forEach((rev) => {
                            // @ts-expect-error they are in fact revealers
                            rev.reveal_child = false;
                        });

                        workspaces().forEach((ws) => {
                            ws.reveal_child = true;
                        });
                    };

                    const updateWorkspaces = () => {
                        Hyprland.workspaces.forEach((ws) => {
                            const currentWs = self.children.find((ch) => {
                                return ch.attribute.id === ws.id;
                            });

                            if (!currentWs && ws.id > 0) {
                                self.add(Workspace({ id: ws.id }));
                            }
                        });
                        self.show_all();

                        // Make sure the order is correct
                        workspaces().forEach((workspace, i) => {
                            // @ts-expect-error
                            workspace?.get_parent()?.reorder_child(
                                workspace,
                                i,
                            );
                        });
                    };

                    self.hook(Hyprland, () => {
                        self.attribute.workspaces =
                            self.children.filter((ch) => {
                                return Hyprland.workspaces.find((ws) => {
                                    // @ts-expect-error
                                    return ws.id === ch.attribute.id;
                                });
                            // @ts-expect-error
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

import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

import { Revealer, CenterBox, Box, EventBox, Fixed, Label } from 'resource:///com/github/Aylur/ags/widget.js';

import { WorkspaceDrop } from './dragndrop.js';
import * as VARS from './variables.js';

const DEFAULT_STYLE = `
    min-width:  ${VARS.SCREEN.X * VARS.SCALE}px;
    min-height: ${VARS.SCREEN.Y * VARS.SCALE}px;
`;

/**
 * @typedef {import('types/widgets/box').default} Box
 * @typedef {import('types/widgets/revealer').default} Revealer
 */


/** @param {Box} box */
export const getWorkspaces = (box) => {
    const children = [];

    box.children.forEach((type) => {
        // @ts-expect-error
        type.children.forEach(
            /** @param {Revealer} row */
            (row) => {
                // @ts-expect-error
                row.child.centerWidget.child.children.forEach(
                    /** @param {Revealer} workspace */
                    (workspace) => {
                        children.push(workspace);
                    },
                );
            },
        );
    });
    box.attribute.workspaces = children.sort((a, b) =>
        a.attribute.id - b.attribute.id);
};

/**
 * @param {number} id
 * @param {string} name
 * @param {boolean} normal
 */
const Workspace = (id, name, normal = true) => {
    const fixed = Fixed({});

    const workspace = Revealer({
        transition: 'slide_right',
        transition_duration: 500,

        attribute: {
            id,
            name,
            get_fixed: () => fixed,
        },

        setup: (self) => {
            if (normal) {
                self.hook(Hyprland, () => {
                    const activeId = Hyprland.active.workspace.id;
                    const active = activeId === self.attribute.id;
                    const ws = Hyprland.getWorkspace(self.attribute.id);

                    self.reveal_child =
                        (ws?.windows && ws.windows > 0) || active;
                });
            }
        },

        child: WorkspaceDrop({
            child: Box({
                class_name: 'workspace',
                css: normal ?

                    DEFAULT_STYLE :

                    `
                      min-width:  ${VARS.SCREEN.X * VARS.SCALE / 2}px;
                      min-height: ${VARS.SCREEN.Y * VARS.SCALE}px;
                    `,

                children: normal ?

                    [fixed] :

                    [
                        fixed,
                        Label({
                            label: '   +',
                            css: 'font-size: 40px;',
                        }),
                    ],
            }),
        }),
    });

    return workspace;
};

/**
 * @param {string} class_name
 * @param {number} i
 */
export const WorkspaceRow = (class_name, i) => {
    const addWorkspace = Workspace(
        class_name === 'special' ? -1 : 1000,
        class_name === 'special' ? 'special' : '',
        false,
    );

    return Revealer({
        transition: 'slide_down',
        hpack: class_name === 'special' ? 'fill' : 'start',

        setup: (self) => {
            self.hook(Hyprland, (rev) => {
                const minId = i * VARS.WORKSPACE_PER_ROW;
                const activeId = Hyprland.active.workspace.id;

                const rowExists = Hyprland.workspaces.some((ws) => {
                    const isInRow = ws.id > minId;
                    const hasClients = ws.windows > 0;
                    const isActive = ws.id === activeId;

                    return isInRow && (hasClients || isActive);
                });

                rev.reveal_child = rowExists;
            });
        },

        child: CenterBox({
            center_widget: EventBox({
                setup: (self) => {
                    self.hook(Hyprland, () => {
                        const maxId = (i + 1) * VARS.WORKSPACE_PER_ROW;
                        const activeId = Hyprland.active.workspace.id;

                        const isSpecial = class_name === 'special';
                        const nextRowExists = Hyprland.workspaces.some((ws) => {
                            const isInNextRow = ws.id > maxId;
                            const hasClients = ws.windows > 0;
                            const isActive = ws.id === activeId;

                            return isInNextRow && (hasClients || isActive);
                        });

                        addWorkspace.reveal_child = isSpecial || !nextRowExists;
                    });
                },

                child: Box({
                    class_name,
                    children: [addWorkspace],
                }),
            }),
        }),
    });
};

/** @param {Box} box */
export const updateWorkspaces = (box) => {
    Hyprland.workspaces.forEach((ws) => {
        const currentWs = box.attribute.workspaces.find(
            /** @param {Revealer} ch */
            (ch) => ch.attribute.id === ws.id,
        );

        if (!currentWs) {
            let type = 0;
            let rowNo = 0;

            if (ws.id < 0) {
                // This means it's a special workspace
                type = 1;
            }
            else {
                rowNo = Math.floor((ws.id - 1) / VARS.WORKSPACE_PER_ROW);
                // @ts-expect-error
                const wsQty = box.children[type].children.length;

                if (rowNo >= wsQty) {
                    for (let i = wsQty; i <= rowNo; ++i) {
                        // @ts-expect-error
                        box.children[type].add(WorkspaceRow(
                            type ? 'special' : 'normal', i,
                        ));
                    }
                }
            }
            // @ts-expect-error
            const row = box.children[type].children[rowNo]
                .child.centerWidget.child;

            row.add(Workspace(ws.id, type ? ws.name : ''));
        }
    });

    // Make sure the order is correct
    box.attribute.workspaces.forEach(
        /**
         * @param {Revealer} workspace
         * @param {number} i
         */
        (workspace, i) => {
            // @ts-expect-error
            workspace?.get_parent()?.reorder_child(workspace, i);
        },
    );
    box.show_all();
};

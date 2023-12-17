import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

import { Revealer, CenterBox, Box, EventBox, Fixed, Label } from 'resource:///com/github/Aylur/ags/widget.js';

import { WorkspaceDrop } from './dragndrop.js';
import * as VARS from './variables.js';

const DEFAULT_STYLE = `
    min-width:  ${VARS.SCREEN.X * VARS.SCALE}px;
    min-height: ${VARS.SCREEN.Y * VARS.SCALE}px;
`;


export const getWorkspaces = (box) => {
    const children = [];

    box.children.forEach((type) => {
        type.children.forEach((row) => {
            row.child.centerWidget.child.children.forEach((ch) => {
                children.push(ch);
            });
        });
    });
    box._workspaces = children.sort((a, b) => a._id - b._id);
};

const Workspace = (id, name, normal = true) => {
    const fixed = Fixed();

    const workspace = Revealer({
        transition: 'slide_right',
        transitionDuration: 500,

        setup: (self) => {
            if (normal) {
                self.hook(Hyprland, () => {
                    const activeId = Hyprland.active.workspace.id;
                    const active = activeId === self._id;

                    self.revealChild = Hyprland.getWorkspace(self._id)
                        ?.windows > 0 || active;
                });
            }
        },

        child: WorkspaceDrop({
            child: Box({
                className: 'workspace',
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

    workspace._id = id;
    workspace._name = name;
    workspace.getFixed = () => fixed;

    return workspace;
};

export const WorkspaceRow = (className, i) => {
    const addWorkspace = Workspace(
        className === 'special' ? -1 : 1000,
        className === 'special' ? 'special' : '',
        false,
    );

    return Revealer({
        transition: 'slide_down',
        hpack: className === 'special' ? '' : 'start',

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

                rev.revealChild = rowExists;
            });
        },

        child: CenterBox({
            children: [null, EventBox({
                setup: (self) => {
                    self.hook(Hyprland, () => {
                        const maxId = (i + 1) * VARS.WORKSPACE_PER_ROW;
                        const activeId = Hyprland.active.workspace.id;

                        const isSpecial = className === 'special';
                        const nextRowExists = Hyprland.workspaces.some((ws) => {
                            const isInNextRow = ws.id > maxId;
                            const hasClients = ws.windows > 0;
                            const isActive = ws.id === activeId;

                            return isInNextRow && (hasClients || isActive);
                        });

                        addWorkspace.revealChild = isSpecial || !nextRowExists;
                    });
                },

                child: Box({
                    className,
                    children: [addWorkspace],
                }),
            }), null],
        }),
    });
};

export const updateWorkspaces = (box) => {
    Hyprland.workspaces.forEach((ws) => {
        const currentWs = box._workspaces.find((ch) => ch._id === ws.id);

        if (!currentWs) {
            let type = 0;
            let rowNo = 0;

            if (ws.id < 0) {
                // This means it's a special workspace
                type = 1;
            }
            else {
                rowNo = Math.floor((ws.id - 1) / VARS.WORKSPACE_PER_ROW);
                const wsQty = box.children[type].children.length;

                if (rowNo >= wsQty) {
                    for (let i = wsQty; i <= rowNo; ++i) {
                        box.children[type].add(WorkspaceRow(
                            type ? 'special' : 'normal', i,
                        ));
                    }
                }
            }
            const row = box.children[type].children[rowNo]
                .child.centerWidget.child;

            row.add(Workspace(ws.id, type ? ws.name : ''));
        }
    });

    // Make sure the order is correct
    box._workspaces.forEach((workspace, i) => {
        workspace.get_parent().reorder_child(workspace, i);
    });
    box.show_all();
};

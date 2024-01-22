import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

import { Revealer, CenterBox, Box, EventBox, Fixed, Label } from 'resource:///com/github/Aylur/ags/widget.js';

import { WorkspaceDrop } from './dragndrop.ts';
import * as VARS from './variables.ts';

const EMPTY_OFFSET = 16;
const DEFAULT_STYLE = `
    min-width:  ${(VARS.SCREEN.X * VARS.SCALE) + EMPTY_OFFSET}px;
    min-height: ${VARS.SCREEN.Y * VARS.SCALE}px;
`;

// Types
import AgsBox from 'types/widgets/box.ts';
import AgsRevealer from 'types/widgets/revealer.ts';
import AgsCenterBox from 'types/widgets/centerbox.ts';
import AgsEventBox from 'types/widgets/eventbox.ts';


export const getWorkspaces = (box: AgsBox) => {
    const children = [] as Array<AgsRevealer>;

    (box.children as Array<AgsBox>).forEach((type) => {
        (type.children as Array<AgsRevealer>).forEach(
            (row) => {
                ((((row.child as AgsCenterBox)
                    .center_widget as AgsEventBox)
                    .child as AgsBox)
                    .children as Array<AgsRevealer>)
                    .forEach((workspace) => {
                        children.push(workspace);
                    });
            },
        );
    });
    box.attribute.workspaces = children.sort((a, b) => {
        return a.attribute.id - b.attribute.id;
    });
};

const Workspace = (id: number, name: string, normal = true) => {
    // @ts-expect-error
    const fixed = Fixed();

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
                      min-width:  ${(VARS.SCREEN.X * VARS.SCALE / 2) +
                        EMPTY_OFFSET}px;
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

export const WorkspaceRow = (class_name: string, i: number) => {
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

export const updateWorkspaces = (box: AgsBox) => {
    Hyprland.workspaces.forEach((ws) => {
        const currentWs = (box.attribute.workspaces as Array<AgsRevealer>).find(
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
                const wsRow = box.children[type] as AgsBox;
                const wsQty = wsRow.children.length;

                if (rowNo >= wsQty) {
                    for (let i = wsQty; i <= rowNo; ++i) {
                        wsRow.add(WorkspaceRow(
                            type ? 'special' : 'normal', i,
                        ));
                    }
                }
            }
            const row = ((((box.children[type] as AgsBox)
                .children[rowNo] as AgsRevealer)
                .child as AgsCenterBox)
                .center_widget as AgsEventBox)
                .child as AgsBox;

            row.add(Workspace(ws.id, type ? ws.name : ''));
        }
    });

    // Make sure the order is correct
    box.attribute.workspaces.forEach(
        (workspace: AgsRevealer, i: number) => {
            (workspace?.get_parent() as AgsBox)
                ?.reorder_child(workspace, i);
        },
    );
    box.show_all();
};

import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import { Revealer, CenterBox, Box, EventBox, Fixed, Label } from 'resource:///com/github/Aylur/ags/widget.js';

import { WorkspaceDrop } from './dragndrop.js';
import * as VARS from './variables.js';

const DEFAULT_STYLE = `min-width:  ${VARS.SCREEN.X * VARS.SCALE}px;
                       min-height: ${VARS.SCREEN.Y * VARS.SCALE}px;`;


export function getWorkspaces(box) {
    const children = [];
    box.children.forEach(type => {
        type.children.forEach(row => {
            row.child.centerWidget.child.children.forEach(ch => {
                children.push(ch);
            });
        });
    });
    box._workspaces = children.sort((a, b) => a._id - b._id);
}

export const WorkspaceRow = (className, i) => Revealer({
    transition: 'slide_down',
    hpack: className === 'special' ? '' : 'start',
    connections: [[Hyprland, rev => {
        const minId = i * VARS.WORKSPACE_PER_ROW;
        const activeId = Hyprland.active.workspace.id;

        rev.revealChild = Hyprland.workspaces
            .some(ws => ws.id > minId &&
                (ws.windows > 0 || ws.id === activeId));
    }]],
    child: CenterBox({
        children: [null, EventBox({
            connections: [[Hyprland, eventbox => {
                const maxId = i * VARS.WORKSPACE_PER_ROW + VARS.WORKSPACE_PER_ROW;
                const activeId = Hyprland.active.workspace.id;

                eventbox.child.children[0].revealChild = className === 'special' ||
                                            !Hyprland.workspaces.some(ws => ws.id > maxId &&
                                                (ws.windows > 0 || ws.id === activeId));
            }]],
            child: Box({
                className: className,
                children: [
                    // the 'add' workspace
                    Workspace(className === 'special' ? -1 : 1000,
                        className === 'special' ? 'special' : '',
                        true),
                ],
            }),
        }), null],
    }),
});

const Workspace = (id, name, extra = false) => {
    let workspace;
    const fixed = Fixed();

    if (!extra) {
        workspace = Revealer({
            transition: 'slide_right',
            transitionDuration: 500,
            connections: [[Hyprland, box => {
                const activeId = Hyprland.active.workspace.id;
                const active = activeId === box._id;

                box.revealChild = Hyprland.getWorkspace(box._id)?.windows > 0 || active;
            }]],
            child: WorkspaceDrop({
                child: Box({
                    className: 'workspace',
                    css: DEFAULT_STYLE,
                    child: fixed,
                }),
            }),
        });
    }
    // 'add' workspace
    else {
        workspace = Revealer({
            transition: 'slide_right',
            child: WorkspaceDrop({
                child: Box({
                    css: `min-width:  ${VARS.SCREEN.X * VARS.SCALE / 2}px;
                          min-height: ${VARS.SCREEN.Y * VARS.SCALE}px;`,
                    children: [
                        fixed,
                        Label({
                            label: '   +',
                            css: 'font-size: 40px;',
                        }),
                    ],
                }),
            }),
        });
    }

    workspace._id = id;
    workspace._name = name;
    workspace.getFixed = () => fixed;
    return workspace;
};

export function updateWorkspaces(box) {
    Hyprland.workspaces.forEach(ws => {
        const currentWs = box._workspaces.find(ch => ch._id == ws.id);
        if (!currentWs) {
            var type = 0;
            var rowNo = 0;

            if (ws.id < 0) {
                // This means it's a special workspace
                type = 1;
            }
            else {
                rowNo = Math.floor((ws.id - 1) / VARS.WORKSPACE_PER_ROW);
                if (rowNo >= box.children[type].children.length) {
                    for (let i = box.children[type].children.length; i <= rowNo; ++i)
                        box.children[type].add(WorkspaceRow(type ? 'special' : 'normal', i));
                }
            }
            var row = box.children[type].children[rowNo].child.centerWidget.child;
            row.add(Workspace(ws.id, type ? ws.name : ''));
        }
    });

    // Make sure the order is correct
    box._workspaces.forEach((workspace, i) => {
        workspace.get_parent().reorder_child(workspace, i);
    });
    box.show_all();
}

import { Hyprland, Widget } from '../../imports.js';
const { Revealer, CenterBox, Box, EventBox, Label, Overlay } = Widget;

import Gtk  from 'gi://Gtk';

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
    halign: className === 'special' ? '' : 'start',
    connections: [[Hyprland, rev => {
        const minId = i * VARS.WORKSPACE_PER_ROW;
        const activeId = Hyprland.active.workspace.id;

        rev.revealChild = Hyprland.workspaces
            .some(ws => ws.id > minId &&
                (ws.windows > 0 || ws.id === activeId));
    }]],
    child: CenterBox({
        children: [null, EventBox({
            // save ref to the 'add' workspace
            properties: [['box']],
            setup: eventbox => eventbox._box = eventbox.child.children[0],

            connections: [[Hyprland, eventbox => {
                const maxId = i * VARS.WORKSPACE_PER_ROW + VARS.WORKSPACE_PER_ROW;
                const activeId = Hyprland.active.workspace.id;

                eventbox._box.revealChild = className === 'special' ||
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
    const fixed = Gtk.Fixed.new();

    if (!extra) {
        workspace = Revealer({
            transition: 'slide_right',
            transitionDuration: 500,
            properties: [
                ['id', id],
                ['name', name],
            ],
            connections: [[Hyprland, box => {
                const activeId = Hyprland.active.workspace.id;
                const active = activeId === box._id;

                box.revealChild = Hyprland.getWorkspace(box._id)?.windows > 0 || active;
            }]],
            child: WorkspaceDrop({
                child: Box({
                    className: 'workspace',
                    style: DEFAULT_STYLE,
                    child: fixed,
                }),
            }),
        });
    }
    // 'add' workspace
    else {
        workspace = Revealer({
            transition: 'slide_right',
            properties: [
                ['id', id],
                ['name', name],
            ],
            child: WorkspaceDrop({
                child: Box({
                    style: `min-width:  ${VARS.SCREEN.X * VARS.SCALE / 2}px;
                            min-height: ${VARS.SCREEN.Y * VARS.SCALE}px;`,
                    children: [
                        fixed,
                        Label({
                            label: '   +',
                            style: 'font-size: 40px;',
                        }),
                    ],
                }),
            }),
        });
    }

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
    box.show_all();

    // Make sure the order is correct
    box._workspaces.forEach((workspace, i) => {
        workspace.get_parent().reorder_child(workspace, i);
    });
}

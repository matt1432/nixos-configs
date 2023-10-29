import { Hyprland, Utils, Widget } from '../../imports.js';
const { Revealer, CenterBox, Box, EventBox, Label, Overlay } = Widget;

import Gtk  from 'gi://Gtk';
import GLib from 'gi://GLib';

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
    connections: [[Hyprland, rev => {
        const minId = i * VARS.WORKSPACE_PER_ROW;
        const activeId = Hyprland.active.workspace.id;

        rev.revealChild = Hyprland.workspaces.some(ws => ws.id > minId &&
                                                        (ws.windows > 0 ||
                                                        ws.id === activeId));
    }]],
    child: CenterBox({
        children: [null, EventBox({
            properties: [['box']],
            setup: eventbox => eventbox._box = eventbox.child.children[0],
            connections: [[Hyprland, eventbox => {
                const maxId = i * VARS.WORKSPACE_PER_ROW + VARS.WORKSPACE_PER_ROW;
                const activeId = Hyprland.active.workspace.id;

                eventbox._box.revealChild = className === 'special' ||
                                                !Hyprland.workspaces.some(ws => ws.id > maxId &&
                                                    (ws.windows > 0 ||
                                                    ws.id === activeId));
            }]],
            child: Box({
                className: className,
                children: [
                    Workspace(className === 'special' ? -1 : 1000,
                        className === 'special' ? 'special' : '',
                        true),
                ],
            }),
        }), null],
    }),
});

// TODO: please make this readable for the love of god
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
                ['timeouts', []],
                ['wasActive', false],
            ],
            connections: [[Hyprland, box => {
                box._timeouts.forEach(timer => {
                    GLib.source_remove(timer);
                    box._timeouts.remove(timer);
                });

                const activeId = Hyprland.active.workspace.id;
                const active = activeId === box._id;

                const rev = box.child.child.get_children()[1];
                const n = activeId > box._id;

                if (Hyprland.getWorkspace(box._id)?.windows > 0 || active) {
                    rev.setStyle(DEFAULT_STYLE);

                    const timer = Utils.timeout(100, () => {
                        box.revealChild = true;
                        box._timeouts.remove(timer);
                    });
                    box._timeouts.push(timer);
                }
                else if (!Hyprland.getWorkspace(box._id)?.windows > 0) {
                    rev.setStyle(DEFAULT_STYLE);

                    const timer = Utils.timeout(100, () => {
                        box.revealChild = false;
                        box._timeouts.remove(timer);
                    });
                    box._timeouts.push(timer);
                    return;
                }

                if (active) {
                    rev.setStyle(`${DEFAULT_STYLE}
                                  transition: margin 0.5s ease-in-out;
                                  opacity: 1;`);
                    box._wasActive = true;
                }
                else if (box._wasActive) {
                    const timer1 = Utils.timeout(120, () => {
                        rev.setStyle(`${DEFAULT_STYLE}
                                      transition: margin 0.5s ease-in-out;
                                      opacity: 1; margin-left: ${n ? '' : '-'}300px;
                                      margin-right: ${n ? '-' : ''}300px;`);
                        box._wasActive = false;
                        box._timeouts.remove(timer1);
                    });
                    box._timeouts.push(timer1);

                    const timer2 = Utils.timeout(500, () => {
                        rev.setStyle(`${DEFAULT_STYLE} opacity: 0;
                                      margin-left: ${n ? '' : '-'}300px;
                                      margin-right: ${n ? '-' : ''}300px;`);
                        box._timeouts.remove(timer2);
                    });
                    box._timeouts.push(timer2);
                }
                else {
                    rev.setStyle(`${DEFAULT_STYLE} opacity: 0;
                                  margin-left: ${n ? '' : '-'}300px;
                                  margin-right: ${n ? '-' : ''}300px;`);
                }
            }]],
            child: WorkspaceDrop({
                child: Overlay({
                    child: Box({
                        className: 'workspace active',
                        style: `${DEFAULT_STYLE} opacity: 0;`,
                    }),
                    overlays: [
                        Box({
                            className: 'workspace active',
                            style: `${DEFAULT_STYLE} opacity: 0;`,
                        }),
                        Box({
                            className: 'workspace',
                            style: DEFAULT_STYLE,
                            child: fixed,
                        }),
                    ],
                }),
            }),
        });
    }
    else {
        workspace = Revealer({
            transition: 'slide_right',
            properties: [
                ['id', id],
                ['name', name],
            ],
            child: WorkspaceDrop({
                child: Overlay({
                    child: Box({
                        className: 'workspace',
                        style: DEFAULT_STYLE,
                    }),
                    overlays: [
                        Box({
                            className: 'workspace active',
                            style: `${DEFAULT_STYLE} opacity: 0;`,
                        }),
                        Box({
                            style: DEFAULT_STYLE,
                            children: [
                                fixed,
                                Label({
                                    label: '   +',
                                    style: 'font-size: 40px;',
                                }),
                            ],
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

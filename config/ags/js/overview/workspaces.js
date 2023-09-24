const { Revealer, CenterBox, Box, EventBox, Label } = ags.Widget;
const { Hyprland } = ags.Service;
const { Gtk } = imports.gi;

import { WorkspaceDrop } from './dragndrop.js';
import * as VARS from './variables.js';

export function getWorkspaces(box) {
  let children = [];
  box.children.forEach(type => {
    type.children.forEach(row => {
      row.child.centerWidget.child.children.forEach(ch => {
        children.push(ch);
      });
    });
  });
  box._workspaces = children.sort((a, b) => a._id - b._id);
};

export const WorkspaceRow = (className, i) => Revealer({
  transition: 'slide_down',
  connections: [[Hyprland, rev => {
    rev.revealChild = Hyprland.workspaces.some(ws => ws.id > i * VARS.WORKSPACE_PER_ROW &&
                                                    (ws.windows > 0 ||
                                                     ws.id === Hyprland.active.workspace.id));
  }]],
  child: CenterBox({
    children: [null, EventBox({
      properties: [['box']],
      setup: eventbox => eventbox._box = eventbox.child.children[0],
      connections: [[Hyprland, eventbox => {
        eventbox._box.revealChild = className === 'special' ||
          !Hyprland.workspaces.some(ws => ws.id > i * VARS.WORKSPACE_PER_ROW + VARS.WORKSPACE_PER_ROW && (ws.windows > 0 || ws.id === Hyprland.active.workspace.id));
      }]],
      child: Box({
        className: className,
        children: [
          Revealer({
            transition: 'slide_right',
            properties: [
              ['id', className === 'special' ? -1 : 1000],
              ['name', className === 'special' ? 'special' : ''],
            ],
            child: WorkspaceDrop({
              child: Box({
                className: 'workspace',
                style: `min-width: ${VARS.SCREEN.X * VARS.SCALE}px;
                        min-height: ${VARS.SCREEN.Y * VARS.SCALE}px;`,
                children: [
                  ags.Widget({
                    type: Gtk.Fixed,
                  }),
                  Label({
                    label: '   +',
                    style: 'font-size: 40px;',
                  }),
                ],
              }),
            }),
          }),
        ],
      }),
    }), null],
  }),
});

const Workspace = (id, name) => Revealer({
  transition: 'slide_right',
  properties: [
    ['id', id],
    ['name', name],
  ],
  connections: [[Hyprland, box => {
    let active = Hyprland.active.workspace.id === box._id;
    box.child.child.toggleClassName('active', active);
    box.revealChild = Hyprland.getWorkspace(box._id)?.windows > 0 || active;
  }]],
  child: WorkspaceDrop({
    child: Box({
      className: 'workspace',
      style: `min-width: ${VARS.SCREEN.X * VARS.SCALE}px;
              min-height: ${VARS.SCREEN.Y * VARS.SCALE}px;`,
      child: ags.Widget({
        type: Gtk.Fixed,
      }),
    }),
  }),
});

export function updateWorkspaces(box) {
  Hyprland.workspaces.forEach(ws => {
    let currentWs = box._workspaces.find(ch => ch._id == ws.id);
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
          for (let i = box.children[type].children.length; i <= rowNo; ++i) {
            box.children[type].add(WorkspaceRow(type ? 'special' : 'normal', i));
          }
        }
      }
      var row = box.children[type].children[rowNo].child.centerWidget.child;
      row.add(Workspace(ws.id, type ? ws.name : ''));
    }
  });
  box.show_all();

  // Make sure the order is correct
  box._workspaces.forEach((workspace, i) => {
    workspace.get_parent().reorder_child(workspace, i)
  });
}

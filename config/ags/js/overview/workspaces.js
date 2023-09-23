const { Revealer, CenterBox, Box } = ags.Widget;
const { Hyprland } = ags.Service;
const { Gtk } = imports.gi;

import { WorkspaceDrop } from './dragndrop.js';
import * as VARS from './variables.js';

export function getWorkspaces(box) {
  let children = [];
  box.children.forEach(type => {
    type.children.forEach(row => {
      row.child.centerWidget.children.forEach(ch => {
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
    children: [null, Box({
      className: className,
    }), null],
  }),
});

const Workspace = id => Revealer({
  transition: 'slide_right',
  properties: [
    ['id', id],
  ],
  connections: [[Hyprland, box => {
    let active = Hyprland.active.workspace.id === box._id;
    box.child.child.toggleClassName('active', active);
    box.revealChild = Hyprland.getWorkspace(box._id)?.windows > 0 || active;
  }]],
  child: WorkspaceDrop({
    id: id,
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
            box.children[type].add(WorkspaceRow('normal', i));
          }
        }
      }
      var row = box.children[type].children[rowNo].child.centerWidget;
      row.add(Workspace(ws.id));
    }
  });
  box.show_all();

  // Make sure the order is correct
  box._workspaces.forEach((workspace, i) => {
    workspace.get_parent().reorder_child(workspace, i)
  });
}

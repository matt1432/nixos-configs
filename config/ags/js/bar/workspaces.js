import { Hyprland, Utils, Widget } from '../../imports.js';
const { Box, Label, Revealer } = Widget;
const { execAsync } = Utils;

import { EventBox } from '../misc/cursorbox.js';


const Workspace = ({ i } = {}) =>
Revealer({
  transition: "slide_right",
  properties: [
    ['id', i],
  ],
  child: EventBox({
    tooltipText: `${i}`,
    onPrimaryClickRelease: () => execAsync(`hyprctl dispatch workspace ${i}`).catch(print),
    child: Box({
      className: 'button',
      child: Label(`${i}`),
      connections: [
        [Hyprland, btn => {
          const occupied = Hyprland.getWorkspace(i)?.windows > 0;
          btn.toggleClassName('active', Hyprland.active.workspace.id === i);
          btn.toggleClassName('occupied', occupied);
          btn.toggleClassName('empty', !occupied);
        }]
      ],
    }),
  }),
});

export const Workspaces = Box({
  className: 'workspaces',
  children: [EventBox({
    child: Box({
      properties: [
        ['workspaces'],

        ['refresh', box => {
          box.children.forEach(rev => rev.reveal_child = false);
          box._workspaces.forEach(ws => {
            ws.revealChild = true;
          });
        }],

        ['updateWs', box => {
          Hyprland.workspaces.forEach(ws => {
            let currentWs = box.children.find(ch => ch._id == ws.id);
            if (!currentWs && ws.id > 0) {
              box.add(Workspace({ i: ws.id}));
            }
          });
          box.show_all();

          // Make sure the order is correct
          box._workspaces.forEach((workspace, i) => {
            workspace.get_parent().reorder_child(workspace, i);
          });
        }],
      ],
      connections: [[Hyprland, box => {
        box._workspaces = box.children.filter(ch => {
          return Hyprland.workspaces.find(ws => ws.id == ch._id)
        }).sort((a, b) => a._id - b._id);

        box._updateWs(box);
        box._refresh(box);
      }]],
    }),
  })],
});

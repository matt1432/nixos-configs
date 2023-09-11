const { Hyprland, Applications } = ags.Service;
const { execAsync } = ags.Utils;
const { Box, Button, Label, Revealer } = ags.Widget;

import { EventBox } from '../misc/cursorbox.js';

const Workspace = ({ i } = {}) =>
Revealer({
  transition: "slide_right",
  child: EventBox({
    setup: widget => {
      widget.set_tooltip_text(`${i}`);
    },
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
      children: Array.from({ length: 15 }, (_, i) => i + 1).map(i => Workspace({ i: i})),
      connections: [[Hyprland, box => {
        let workspaces = [];
        Hyprland.workspaces.forEach(ws => {
          if (ws.id > 0) workspaces.push(ws);
        });

        box.children.forEach(rev => rev.reveal_child = false);
        workspaces.forEach(ws => {
          box.children[ws.id - 1].reveal_child = true;
        });
      }]],
    }),
  })],
});

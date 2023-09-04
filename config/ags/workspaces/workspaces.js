// https://github.com/Aylur/dotfiles/blob/f03e58ba0d3b56f1144631c179ab27357e466753/.config/ags/modules/hyprland.js#L4
import Gdk from 'gi://Gdk';
const display = Gdk.Display.get_default();
const { App } = ags;
const { Hyprland, Applications } = ags.Service;
const { execAsync, lookUpIcon } = ags.Utils;
const { Box, Button, EventBox, Label, Icon } = ags.Widget;

export const Workspace = ({ i, } = {}) => 
EventBox({
  onPrimaryClickRelease: () => execAsync(`hyprctl dispatch workspace ${i}`).catch(print),
  onHover: box => {
    box.window.set_cursor(Gdk.Cursor.new_from_name(display, 'pointer'));
  },
  onHoverLost: box => {
    box.window.set_cursor(null);
  },
  child: Box({
    className: 'button',
    child: Label(`${i}`),
    connections: [
      [Hyprland, btn => {
        const { workspaces, active } = Hyprland;
        const occupied = workspaces.has(i) && workspaces.get(i).windows > 0;
        btn.toggleClassName('active', active.workspace.id === i);
        btn.toggleClassName('occupied', occupied);
        btn.toggleClassName('empty', !occupied);
      }]
    ],
  }),
});

var prev = Hyprland.active.workspace.id;

export const Workspaces = props => Box({
  className: 'workspaces panel-button',
  children: [EventBox({
    child: Box({
      connections: [[Hyprland, box => {
        let workspaces = [];

        new Promise(resolve => {

          Hyprland.workspaces.forEach(ws => {
            if (ws.id > 0) {
              workspaces.push(ws);
            }
          });

          resolve();
        }).then(value => {

          if (workspaces.length > 0) {
            let currentId = Hyprland.active.workspace.id;
            let qtyChange = Number(currentId - box.children.length);

            if (qtyChange != 0 && currentId != prev) {
              box.get_children().forEach(ch => ch.destroy());
              box.children = Array.from(
                { length: Math.max(...workspaces.map(ws => ws.id)) },
                (_, i) => i + 1).map(i => Workspace({ i: i}));
            }
            prev = currentId;
          }

        });
      }]],
    }),
  })],
});

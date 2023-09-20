const { Window, Box, CenterBox, Icon } = ags.Widget;
const { Hyprland, Applications } = ags.Service;
const { Gtk } = imports.gi;

import { EventBox } from '../misc/cursorbox.js';

const SCALE = 0.11;
const MARGIN = 8;

export const Overview = Window({
  name: 'overview',
  layer: 'overlay',
  //popup: true,
  anchor: 'top',
  margin: [ 0, 0, 0, 0 ],
  child: Box({
    className: 'overview',
    vertical: true,
    children: [
      CenterBox({
        children: [
          null,
          Box({
            className: 'normal',
          }),
          null,
        ],
      }),
      CenterBox({
        children: [
          null,
          Box({
            className: 'special',
          }),
          null,
        ],
      }),
    ],
    connections: [
      [Hyprland, box => {
        box._workspaces = box.children[0].centerWidget.children.concat(
                         box.children[1].centerWidget.children)
        let newWorkspaces = Hyprland.workspaces;

        if (newWorkspaces.length > box._workspaces.length) {
          box._updateWs(box);
        }

        if (box._canUpdate)
          box._updateApps(box);

      }],
    ],
    properties: [
      ['canUpdate', true],
      ['workspaces'],
      ['clients'],

      ['updateApps', box => {
        ags.Utils.execAsync('hyprctl clients -j')
        .then(result => {
          box._clients = JSON.parse(result).filter(client => client.class)

          box._workspaces.forEach(workspace => {
            let fixed = workspace.children[0].child;
            fixed.get_children().forEach(ch => ch.destroy());

            box._clients.filter(app => app.workspace.id == workspace._id).forEach(app => {
              let active = '';
              if (app.address == Hyprland.active.client.address) {
                active = 'active';
              }

              if (app.size[0] === 0) {
                app.size[0] = 1524;
                app.size[1] = 908;
              }

              fixed.put(
                Icon({
                  className: `window ${active}`,
                  style: `min-width: ${app.size[0] * SCALE - MARGIN}px;
                          min-height: ${app.size[1] * SCALE - MARGIN}px;`,
                  icon: app.class,
                  size: 40,
                }),
                app.at[0] * SCALE,
                app.at[1] * SCALE
              );
            });
            fixed.show_all();
          });
        }).catch(print);
      }],

      ['updateWs', box => {
        if (!box._canUpdate)
          return;

        box._canUpdate = false;
        const id = Hyprland.instance.connect('changed', () => {
          Hyprland.workspaces.forEach(ws => {
            if (box._workspaces.some(ch => ch._id == ws.id)) 
              return;

            var childI = 0;
            if (ws.id < 0) {
              childI = 1;
            }

            box.children[childI].centerWidget.add(
              Box({
                properties: [['id', ws.id]],
                className: 'workspace',
                child: EventBox({
                  tooltipText: `Workspace: ${ws.id}`,
                  child: ags.Widget({
                    type: Gtk.Fixed,
                  }),
                }),
              })
            );
          });
          box.show_all();
          if (box.children[0].centerWidget.children.length > 0) {
            Hyprland.instance.disconnect(id);
            box._canUpdate = true;
            box._updateApps(box);
          }
        });
      }],
    ],
  }),
});

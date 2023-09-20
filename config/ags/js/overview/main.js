const { Window, Box, CenterBox, Icon, Revealer } = ags.Widget;
const { Hyprland, Applications } = ags.Service;
const { Gtk } = imports.gi;

import { EventBox } from '../misc/cursorbox.js';

const SCALE = 0.11;
const MARGIN = 8;
const DEFAULT_SPECIAL = {
  SIZE_X: 1524,
  SIZE_Y: 908,
  POS_X: 197,
  POS_Y: 170,
};

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
        let childI = 0;
        box._workspaces = box.children[childI++].centerWidget.children.concat(
                          box.children[childI].centerWidget.children)
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
            let toRemove = fixed.get_children();

            box._clients.filter(app => app.workspace.id == workspace._id).forEach(app => {
              let active = '';
              if (app.address == Hyprland.active.client.address) {
                active = 'active';
              }

              // Special workspaces that haven't been opened yet
              // return a size of 0. We need to set them to default
              // values to show the workspace properly
              if (app.size[0] === 0) {
                app.size[0] = DEFAULT_SPECIAL.SIZE_X;
                app.size[1] = DEFAULT_SPECIAL.SIZE_Y;
                app.at[0] = DEFAULT_SPECIAL.POS_X;
                app.at[1] = DEFAULT_SPECIAL.POS_Y;
              }

              let existingApp = fixed.get_children().find(ch => ch._address == app.address);
              toRemove.splice(toRemove.indexOf(existingApp), 1);

              if (existingApp) {
                fixed.move(
                  existingApp,
                  app.at[0] * SCALE,
                  app.at[1] * SCALE,
                );
                existingApp.child.className = `window ${active}`;
                existingApp.child.style = `min-width: ${app.size[0] * SCALE - MARGIN}px;
                                           min-height: ${app.size[1] * SCALE - MARGIN}px;`;
              }
              else {
                fixed.put(
                  Revealer({
                    transition: 'slide_right',
                    connections: [[Hyprland, rev => {
                      rev.revealChild = true;
                    }]],
                    properties: [
                      ['address', app.address],
                      ['toDestroy', false]
                    ],
                    child: Icon({
                      className: `window ${active}`,
                      style: `min-width: ${app.size[0] * SCALE - MARGIN}px;
                              min-height: ${app.size[1] * SCALE - MARGIN}px;`,
                      icon: app.class,
                      size: 40,
                    }),
                  }),
                  app.at[0] * SCALE,
                  app.at[1] * SCALE,
                );
              }
            });
            fixed.show_all();
            toRemove.forEach(ch => {
              if (ch._toDestroy) {
                ch.destroy();
              }
              else {
                ch.revealChild = false;
                ch._toDestroy = true;
              }
            });
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
          if (box._workspaces.length > 0) {
            Hyprland.instance.disconnect(id);
            box._canUpdate = true;
            box._updateApps(box);
          }
        });
      }],
    ],
  }),
});

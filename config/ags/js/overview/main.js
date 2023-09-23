const { Window, Box, CenterBox, Icon, Revealer, EventBox } = ags.Widget;
const { closeWindow } = ags.App;
const { execAsync } = ags.Utils;
const { Hyprland } = ags.Service;
const { Gtk, Gdk } = imports.gi;
import Cairo from 'cairo';

import { Button } from '../misc/cursorbox.js';
import { PopUp } from '../misc/popup.js';

const WORKSPACE_PER_ROW = 6;
const SCALE = 0.11;
const ICON_SCALE = 0.8;
const MARGIN = 8;
const SCREEN = {
  X: 1920,
  Y: 1200,
}
const DEFAULT_SPECIAL = {
  SIZE_X: 1524,
  SIZE_Y: 908,
  POS_X: 197,
  POS_Y: 170,
};
const IconStyle = app => `min-width: ${app.size[0] * SCALE - MARGIN}px;
                          min-height: ${app.size[1] * SCALE - MARGIN}px;
                          font-size: ${Math.min(app.size[0] * SCALE - MARGIN,
                            app.size[1] * SCALE - MARGIN) * ICON_SCALE}px;`;
Array.prototype.remove = function (el) { this.splice(this.indexOf(el), 1) };

const TARGET = [Gtk.TargetEntry.new('text/plain', Gtk.TargetFlags.SAME_APP, 0)];

export function createSurfaceFromWidget(widget) {
    const alloc = widget.get_allocation();
    const surface = new Cairo.ImageSurface(
        Cairo.Format.ARGB32,
        alloc.width,
        alloc.height,
    );
    const cr = new Cairo.Context(surface);
    cr.setSourceRGBA(255, 255, 255, 0);
    cr.rectangle(0, 0, alloc.width, alloc.height);
    cr.fill();
    widget.draw(cr);

    return surface;
}

const WorkspaceRow = (className, i) => Revealer({
  transition: 'slide_down',
  connections: [[Hyprland, rev => {
    rev.revealChild = Hyprland.workspaces.some(ws => ws.id > i * WORKSPACE_PER_ROW &&
                                                    (ws.windows > 0 ||
                                                     ws.id === Hyprland.active.workspace.id));
  }]],
  child: CenterBox({
    children: [null, Box({
      className: className,
    }), null],
  }),
});

const OverviewWidget = Box({
  className: 'overview',
  vertical: true,
  children: [
    Box({
      vertical: true,
      children: [
        WorkspaceRow('normal', 0),
      ],
    }),
    Box({
      vertical: true,
      children: [
        WorkspaceRow('special', 0),
      ],
    }),
  ],
  connections: [
    [Hyprland, box => {
      box._getWorkspaces(box);
      box._updateWs(box);
      box._updateApps(box);
    }],
  ],
  properties: [
    ['workspaces'],

    ['getWorkspaces', box => {
      let children = [];
      box.children.forEach(type => {
        type.children.forEach(row => {
          row.child.centerWidget.children.forEach(ch => {
            children.push(ch);
          });
        });
      });
      box._workspaces = children.sort((a, b) => a._id - b._id);
    }],

    ['updateWs', box => {
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
            rowNo = Math.floor((ws.id - 1) / WORKSPACE_PER_ROW);
            if (rowNo >= box.children[type].children.length) {
              for (let i = box.children[type].children.length; i <= rowNo; ++i) {
                box.children[type].add(WorkspaceRow('normal', i));
              }
            }
          }

          var row = box.children[type].children[rowNo].child.centerWidget;

          currentWs = Revealer({
            transition: 'slide_right',
            properties: [
              ['id', ws.id],
            ],
            connections: [[Hyprland, box => {
              let active = Hyprland.active.workspace.id === box._id;
              box.child.child.toggleClassName('active', active);
              box.revealChild = Hyprland.getWorkspace(box._id)?.windows > 0 || active;
            }]],
            child: EventBox({
              tooltipText: `Workspace: ${ws.id}`,
              child: Box({
                className: 'workspace',
                style: `min-width: ${SCREEN.X * SCALE}px;
                        min-height: ${SCREEN.Y * SCALE}px;`,
                setup: eventbox => {
                  eventbox.drag_dest_set(Gtk.DestDefaults.ALL, TARGET, Gdk.DragAction.COPY);
                  eventbox.connect('drag-data-received', (_w, _c, _x, _y, data) => {
                    execAsync(`hyprctl dispatch movetoworkspacesilent ${ws.id},address:${data.get_text()}`)
                      .catch(print);
                  });
                },
                child: ags.Widget({
                  type: Gtk.Fixed,
                }),
              }),
            }),
          });
          row.add(currentWs);
        }
      });
      box.show_all();

      // Make sure the order is correct
      box._workspaces.forEach((workspace, i) => {
        workspace.get_parent().reorder_child(workspace, i)
      });
    }],

    ['updateApps', box => {
      ags.Utils.execAsync('hyprctl clients -j')
      .then(result => {
        let clients = JSON.parse(result).filter(client => client.class)

        box._workspaces.forEach(workspace => {
          let fixed = workspace.child.child.children[0];
          let toRemove = fixed.get_children();

          clients.filter(app => app.workspace.id == workspace._id).forEach(app => {
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
            toRemove.remove(existingApp);

            if (existingApp) {
              fixed.move(
                existingApp,
                app.at[0] * SCALE,
                app.at[1] * SCALE,
              );
              existingApp.child.child.className = `window ${active}`;
              existingApp.child.child.style = IconStyle(app);
            }
            else {
              fixed.put(
                Revealer({
                  transition: 'crossfade',
                  setup: rev => {
                    rev.revealChild = true;
                  },
                  properties: [
                    ['address', app.address],
                    ['toDestroy', false]
                  ],
                  child: Button({
                    onSecondaryClickRelease: () => {
                      execAsync(`hyprctl dispatch closewindow address:${address}`)
                        .catch(print)
                    },
                    onPrimaryClickRelease: () => {
                      if (app.class === 'thunderbird' || app.class === 'Spotify')
                        execAsync(['bash', '-c', `$AGS_PATH/launch-app.sh ${app.class}`])
                          .then(() => closeWindow('overview'))
                          .catch(print);
                      else
                        execAsync(`hyprctl dispatch focuswindow address:${app.address}`)
                          .then(() => closeWindow('overview'))
                          .catch(print);
                    },
                    setup: button => {
                      button.drag_source_set(Gdk.ModifierType.BUTTON1_MASK, TARGET, Gdk.DragAction.COPY);
                      button.connect('drag-data-get', (_w, _c, data) => data.set_text(app.address, app.address.length));
                      button.connect('drag-begin', (_, context) => {
                        Gtk.drag_set_icon_surface(context, createSurfaceFromWidget(button));
                        button.get_parent().revealChild = false;
                      });
                      button.connect('drag-end', () => button.get_parent().revealChild = true);
                    },
                    child: Icon({
                      className: `window ${active}`,
                      style: IconStyle(app),
                      icon: app.class,
                    }),
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

  ],
});

export const Overview = Window({
  name: 'overview',
  layer: 'overlay',
  child: PopUp({
    name: 'overview',
    transition: 'crossfade',
    child: OverviewWidget,
  }),
});

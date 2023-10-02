import { App, Hyprland, Utils, Widget } from '../../imports.js';
const { Icon, Revealer } = Widget;
const { closeWindow } = App;
const { execAsync } = Utils;

import { WindowButton } from './dragndrop.js';
import * as VARS from './variables.js';

Array.prototype.remove = function (el) { this.splice(this.indexOf(el), 1) };

const IconStyle = app => `min-width: ${app.size[0] * VARS.SCALE - VARS.MARGIN}px;
                          min-height: ${app.size[1] * VARS.SCALE - VARS.MARGIN}px;
                          font-size: ${Math.min(app.size[0] * VARS.SCALE - VARS.MARGIN,
                            app.size[1] * VARS.SCALE - VARS.MARGIN) * VARS.ICON_SCALE}px;`;


const Client = (client, active, clients) => Revealer({
  transition: 'crossfade',
  setup: rev => {
    rev.revealChild = true;
  },
  properties: [
    ['address', client.address],
    ['toDestroy', false]
  ],
  child: WindowButton({
    address: client.address,
    onSecondaryClickRelease: () => {
      execAsync(`hyprctl dispatch closewindow address:${client.address}`)
        .catch(print)
    },
    onPrimaryClickRelease: () => {
      if (client.workspace.id < 0) {
        if (client.workspace.name === 'special') {
          execAsync(`hyprctl dispatch movetoworkspacesilent special:${client.workspace.id},address:${client.address}`)
            .then(execAsync(`hyprctl dispatch togglespecialworkspace ${client.workspace.id}`)
              .then(() => closeWindow('overview'))
              .catch(print))
            .catch(print);
        }
        else {
          execAsync(`hyprctl dispatch togglespecialworkspace ${String(client.workspace.name)
                                                                .replace('special:', '')}`)
            .then(() => closeWindow('overview'))
            .catch(print);
        }
      }
      else {
        // close special workspace if one is opened
        let activeAddress = Hyprland.active.client.address;
        let currentActive = clients.find(c => c.address === activeAddress)

        if (currentActive && currentActive.workspace.id < 0)
          execAsync(`hyprctl dispatch togglespecialworkspace ${String(currentActive.workspace.name)
                                                                .replace('special:', '')}`).catch(print);
        execAsync(`hyprctl dispatch focuswindow address:${client.address}`)
          .then(() => closeWindow('overview'))
          .catch(print);
      }
    },
    child: Icon({
      className: `window ${active}`,
      style: IconStyle(client) + 'font-size: 10px;',
      icon: client.class,
    }),
  }),
});

export function updateClients(box) {
  execAsync('hyprctl clients -j')
  .then(result => {
    let clients = JSON.parse(result).filter(client => client.class)

    box._workspaces.forEach(workspace => {
      let fixed = workspace.child.child.overlays[0].children[0];
      let toRemove = fixed.get_children();

      clients.filter(client => client.workspace.id == workspace._id).forEach(client => {
        let active = '';
        if (client.address == Hyprland.active.client.address) {
          active = 'active';
        }

        // Special workspaces that haven't been opened yet
        // return a size of 0. We need to set them to default
        // values to show the workspace properly
        if (client.size[0] === 0) {
          client.size[0] = VARS.DEFAULT_SPECIAL.SIZE_X;
          client.size[1] = VARS.DEFAULT_SPECIAL.SIZE_Y;
          client.at[0] = VARS.DEFAULT_SPECIAL.POS_X;
          client.at[1] = VARS.DEFAULT_SPECIAL.POS_Y;
        }

        let existingClient = fixed.get_children().find(ch => ch._address == client.address);
        toRemove.remove(existingClient);

        if (existingClient) {
          fixed.move(
            existingClient,
            client.at[0] * VARS.SCALE,
            client.at[1] * VARS.SCALE,
          );
          existingClient.child.child.className = `window ${active}`;
          existingClient.child.child.style = IconStyle(client);
        }
        else {
          fixed.put(
            Client(client, active, clients),
            client.at[0] * VARS.SCALE,
            client.at[1] * VARS.SCALE,
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
};

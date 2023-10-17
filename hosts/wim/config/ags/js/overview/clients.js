import { App, Hyprland, Utils, Widget } from '../../imports.js';
const { Icon, Revealer } = Widget;
const { execAsync } = Utils;

import { WindowButton } from './dragndrop.js';
import * as VARS from './variables.js';

// Has to be a traditional function for 'this' scope
Array.prototype.remove = function (el) { this.splice(this.indexOf(el), 1) };

const scale = size => size * VARS.SCALE - VARS.MARGIN;
const getFontSize = client => Math.min(scale(client.size[0]),
  scale(client.size[1])) * VARS.ICON_SCALE;

const IconStyle = client => `transition: font-size 0.2s linear;
                             min-width:  ${scale(client.size[0])}px;
                             min-height: ${scale(client.size[1])}px;
                             font-size:  ${getFontSize(client)}px;`;


const Client = (client, active, clients) => {
  let wsName = String(client.workspace.name).replace('special:', '');
  let wsId = client.workspace.id;
  let addr = `address:${client.address}`;

  // FIXME: special workspaces not closing when in one and clicking on normal client
  return Revealer({
    transition: 'crossfade',
    setup: rev => rev.revealChild = true,
    properties: [
      ['address', client.address],
      ['toDestroy', false]
    ],
    child: WindowButton({
      address: client.address,
      onSecondaryClickRelease: () => {
        execAsync(`hyprctl dispatch closewindow ${addr}`)
          .catch(print);
      },

      onPrimaryClickRelease: () => {
        if (wsId < 0) {
          if (client.workspace.name === 'special') {
            execAsync(`hyprctl dispatch
              movetoworkspacesilent special:${wsId},${addr}`)
            .then(

              execAsync(`hyprctl dispatch togglespecialworkspace ${wsId}`).then(
                () => App.closeWindow('overview')
              ).catch(print)

            ).catch(print);
          }
          else {
            execAsync(`hyprctl dispatch togglespecialworkspace ${wsName}`).then(
              () => App.closeWindow('overview')
            ).catch(print);
          }
        }
        else {
          // close special workspace if one is opened
          let activeAddress = Hyprland.active.client.address;
          let currentActive = clients.find(c => c.address === activeAddress)

          if (currentActive && currentActive.workspace.id < 0) {
            execAsync(`hyprctl dispatch togglespecialworkspace ${wsName}`)
              .catch(print);
          }
          execAsync(`hyprctl dispatch focuswindow ${addr}`).then(
            () => App.closeWindow('overview')
          ).catch(print);
        }
      },

      child: Icon({
        className: `window ${active}`,
        style: IconStyle(client) + 'font-size: 10px;',
        icon: client.class,
      }),
    }),
  });
};

export function updateClients(box) {
  execAsync('hyprctl clients -j').then(out => {
    let clients = JSON.parse(out).filter(client => client.class)

    box._workspaces.forEach(workspace => {
      let fixed = workspace.getFixed();
      let toRemove = fixed.get_children();

      clients.filter(client => client.workspace.id == workspace._id)
      .forEach(client => {
        let active = '';
        if (client.address == Hyprland.active.client.address) {
          active = 'active';
        }

        // TODO: fix multi monitor issue. this is just a temp fix
        client.at[1] -= 2920;

        // Special workspaces that haven't been opened yet
        // return a size of 0. We need to set them to default
        // values to show the workspace properly
        if (client.size[0] === 0) {
          client.size[0] = VARS.DEFAULT_SPECIAL.SIZE_X;
          client.size[1] = VARS.DEFAULT_SPECIAL.SIZE_Y;
          client.at[0] = VARS.DEFAULT_SPECIAL.POS_X;
          client.at[1] = VARS.DEFAULT_SPECIAL.POS_Y;
        }

        let newClient = [
          fixed.get_children().find(ch => ch._address == client.address),
          client.at[0] * VARS.SCALE,
          client.at[1] * VARS.SCALE,
        ];

        if (newClient[0]) {
          toRemove.remove(newClient[0]);
          fixed.move(...newClient);
        }
        else {
          newClient[0] = Client(client, active, clients);
          fixed.put(...newClient);
        }

        // Set a timeout here to have an animation when the icon first appears
        setTimeout(() => {
          newClient[0].child.child.className = `window ${active}`;
          newClient[0].child.child.style = IconStyle(client);
        }, 1);
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

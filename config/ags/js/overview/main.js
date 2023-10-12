import { App, Hyprland, Widget } from '../../imports.js';
const { Box } = Widget;

import { PopupWindow } from '../misc/popup.js';
import { WorkspaceRow, getWorkspaces, updateWorkspaces } from './workspaces.js';
import { updateClients } from './clients.js';

function update(box) {
  box._getWorkspaces(box);
  box._updateWorkspaces(box);
  box._updateClients(box);
}

export default PopupWindow({
  name: 'overview',
  transition: 'crossfade',

  child: Box({
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
    // The timeout is because the list of clients is async
    setup: box => setTimeout(() => update(box), 100),
    connections: [
      [Hyprland, box => {
        if (!App.getWindow('overview').visible)
          return;

        print('running overview');
        update(box);
      }],
    ],
    properties: [
      ['workspaces'],

      ['getWorkspaces', getWorkspaces],
      ['updateWorkspaces', updateWorkspaces],
      ['updateClients', updateClients],
    ],
  }),

});

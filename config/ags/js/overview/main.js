import { Hyprland, Widget } from '../../imports.js';
const { Window, Box } = Widget;

import { PopUp } from '../misc/popup.js';
import { WorkspaceRow, getWorkspaces, updateWorkspaces } from './workspaces.js';
import { updateClients } from './clients.js';


export default Window({
  name: 'overview',
  layer: 'overlay',
  popup: true,

  child: PopUp({
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
      connections: [
        [Hyprland, box => {
          box._getWorkspaces(box);
          box._updateWorkspaces(box);
          box._updateClients(box);
        }],
      ],
      properties: [
        ['workspaces'],

        ['getWorkspaces', getWorkspaces],
        ['updateWorkspaces', updateWorkspaces],
        ['updateClients', updateClients],
      ],
    }),

  }),
});

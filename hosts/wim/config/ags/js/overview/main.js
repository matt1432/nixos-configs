import { App, Hyprland, Widget } from '../../imports.js';
const { Box } = Widget;

import PopupWindow from '../misc/popup.js';
import { WorkspaceRow, getWorkspaces, updateWorkspaces } from './workspaces.js';
import { updateClients } from './clients.js';


function update(box) {
    getWorkspaces(box);
    updateWorkspaces(box);
    updateClients(box);
}

export default () => PopupWindow({
    name: 'overview',
    transition: 'crossfade',
    closeOnUnfocus: 'none',
    onOpen: child => update(child),

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
        connections: [[Hyprland, self => {
            if (!App.getWindow('overview').visible)
                return;

            update(self);
        }]],
        properties: [
            ['workspaces'],
        ],
    }),

});

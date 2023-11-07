import App      from 'resource:///com/github/Aylur/ags/app.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import { Box, Overlay } from 'resource:///com/github/Aylur/ags/widget.js';
import { timeout } from 'resource:///com/github/Aylur/ags/utils.js';

import PopupWindow from '../misc/popup.js';
import { WorkspaceRow, getWorkspaces, updateWorkspaces } from './workspaces.js';
import { Highlighter, updateCurrentWorkspace } from './current-workspace.js';
import { updateClients } from './clients.js';


function update(box) {
    getWorkspaces(box);
    updateWorkspaces(box);
    updateClients(box);
    updateCurrentWorkspace(box);
}

// FIXME: can't drag in workspaces that are before the highlight
// TODO: have a 'page' for each monitor, arrows on both sides to loop through
export default () => PopupWindow({
    name: 'overview',
    closeOnUnfocus: 'none',
    onOpen: child => update(child.child),

    child: Overlay({
        // FIXME: see if we can get rid of this timeout
        setup: self => timeout(1, () => self.pass_through = true),

        overlays: [Highlighter()],
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
    }),

});

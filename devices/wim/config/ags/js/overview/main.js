import { App, Hyprland, Widget } from '../../imports.js';
const { Box, Overlay } = Widget;

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

export default () => PopupWindow({
    name: 'overview',
    closeOnUnfocus: 'none',
    onOpen: child => update(child.child),

    child: Overlay({
        setup: self => {
            self.set_overlay_pass_through(
                self.get_children()[1],
                true,
            );
        },
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

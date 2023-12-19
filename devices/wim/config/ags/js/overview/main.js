import App from 'resource:///com/github/Aylur/ags/app.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

import { Box, Overlay } from 'resource:///com/github/Aylur/ags/widget.js';

import PopupWindow from '../misc/popup.js';
import { WorkspaceRow, getWorkspaces, updateWorkspaces } from './workspaces.js';
import { Highlighter, updateCurrentWorkspace } from './current-workspace.js';
import { updateClients } from './clients.js';




// TODO: have a 'page' for each monitor, arrows on both sides to loop through
export const Overview = () => {
    const highlighter = Highlighter();

    const mainBox = Box({
        // Do this for scss hierarchy
        className: 'overview',
        css: 'all: unset',

        vertical: true,
        vpack: 'center',
        hpack: 'center',

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

        setup: (self) => {
            self.hook(Hyprland, () => {
                if (!App.getWindow('overview').visible) {
                    return;
                }

                self.update();
            });
        },

        properties: [
            ['workspaces'],
        ],
    });

    mainBox.update = () => {
        getWorkspaces(mainBox);
        updateWorkspaces(mainBox);
        updateClients(mainBox);
        updateCurrentWorkspace(mainBox, highlighter);
    };

    const widget = Overlay({
        overlays: [highlighter, mainBox],

        child: Box({
            className: 'overview',
            css: `
                min-height: ${mainBox.get_allocated_height()}px;
                min-width: ${mainBox.get_allocated_width()}px;
            `,
        }),

        // TODO: throttle his?
        setup: (self) => {
            self.on('get-child-position', (_, ch) => {
                if (ch === mainBox) {
                    self.child.setCss(`
                        transition: min-height 0.2s ease, min-width 0.2s ease;
                        min-height: ${mainBox.get_allocated_height()}px;
                        min-width: ${mainBox.get_allocated_width()}px;
                    `);
                }
            });
        },
    });

    widget.getChild = () => mainBox;

    return widget;
};

export default () => {
    const win = PopupWindow({
        name: 'overview',
        blur: true,
        close_on_unfocus: 'none',
        onOpen: () => {
            win.attribute.set_child(Overview());
            win.attribute.get_child().getChild().update();
        },
    });

    return win;
};

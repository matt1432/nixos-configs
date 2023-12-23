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
        class_name: 'overview',
        css: 'all: unset',

        vertical: true,
        vpack: 'center',
        hpack: 'center',

        attribute: {
            workspaces: [],

            update: () => {
                getWorkspaces(mainBox);
                updateWorkspaces(mainBox);
                updateClients(mainBox);
                updateCurrentWorkspace(mainBox, highlighter);
            },
        },

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
                if (!App.getWindow('overview')?.visible) {
                    return;
                }

                self?.attribute.update();
            });
        },
    });

    const widget = Overlay({
        overlays: [highlighter, mainBox],

        attribute: {
            get_child: () => mainBox,
        },

        child: Box({
            class_name: 'overview',
            css: `
                min-height: ${mainBox.get_allocated_height()}px;
                min-width: ${mainBox.get_allocated_width()}px;
            `,
        }),

        // TODO: throttle his?
        setup: (self) => {
            self.on('get-child-position', (_, ch) => {
                if (ch === mainBox) {
                    // @ts-expect-error
                    self.child.setCss(`
                        transition: min-height 0.2s ease, min-width 0.2s ease;
                        min-height: ${mainBox.get_allocated_height()}px;
                        min-width: ${mainBox.get_allocated_width()}px;
                    `);
                }
            });
        },
    });

    return widget;
};

export default () => {
    const win = PopupWindow({
        name: 'overview',
        blur: true,
        close_on_unfocus: 'none',
        onOpen: () => {
            win.attribute.set_child(Overview());
            win.attribute.get_child().attribute.get_child().attribute.update();
        },
    });

    return win;
};

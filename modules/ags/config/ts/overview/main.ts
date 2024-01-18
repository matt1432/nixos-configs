import App from 'resource:///com/github/Aylur/ags/app.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

import { Box, Overlay, Window } from 'resource:///com/github/Aylur/ags/widget.js';

import { WorkspaceRow, getWorkspaces, updateWorkspaces } from './workspaces.ts';
import { Highlighter, updateCurrentWorkspace } from './current-workspace.ts';
import { updateClients } from './clients.ts';

// Types
import AgsBox from 'types/widgets/box.ts';
import AgsOverlay from 'types/widgets/overlay.ts';


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

                self.attribute.update();
            });
        },
    });

    const widget = Overlay({
        overlays: [highlighter, mainBox],

        attribute: {
            get_child: () => mainBox,
            closing: false,
        },

        // Make size of overlay big enough for content
        child: Box({
            class_name: 'overview',
            css: `
                min-height: ${mainBox.get_allocated_height()}px;
                min-width: ${mainBox.get_allocated_width()}px;
            `,
        }),

        // TODO: throttle this?
        setup: (self) => {
            self.on('get-child-position', (_, ch) => {
                if (ch === mainBox && !self.attribute.closing) {
                    (self.child as AgsBox).setCss(`
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

// FIXME: can't use PopupWindow because this is an overlay already
export default () => {
    const transition_duration = 800;
    const win = Window({
        name: 'overview',
        visible: false,

        // Needs this to have space
        // allocated at the start
        child: Box({
            css: `
                min-height: 1px;
                min-width: 1px;
                padding: 1px;
            `,
        }),

        attribute: { close_on_unfocus: 'none' },

        setup: (self) => {
            const name = 'overview';

            Hyprland.sendMessage('[[BATCH]] ' +
                    `keyword layerrule ignorealpha[0.97],${name}; ` +
                    `keyword layerrule blur,${name}`);

            self.hook(App, (_, currentName, isOpen) => {
                if (currentName === self.name) {
                    if (isOpen) {
                        self.child = Overview();
                        self.show_all();

                        (self.child as AgsOverlay)
                            .attribute.get_child().attribute.update();
                    }
                    else {
                        (self.child as AgsOverlay).attribute.closing = true;

                        ((self.child as AgsOverlay)
                            .child as AgsBox).css = `
                                min-height: 1px;
                                min-width: 1px;
                                transition: all
                                    ${transition_duration - 10}ms ease;
                            `;
                    }
                }
            });
        },
    });

    return win;
};

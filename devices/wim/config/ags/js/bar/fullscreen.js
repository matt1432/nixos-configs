import App         from 'resource:///com/github/Aylur/ags/app.js';
import Hyprland    from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Variable    from 'resource:///com/github/Aylur/ags/variable.js';

import { Box, EventBox, Overlay, Revealer } from 'resource:///com/github/Aylur/ags/widget.js';
import { timeout } from 'resource:///com/github/Aylur/ags/utils.js';

import { RoundedCorner } from '../screen-corners.js';

const Revealed = Variable(true);
const Hovering = Variable(false);
const wStyle = 'background: rgba(0, 0, 0, 0.5);';


Hyprland.connect('changed', () => {
    const workspace = Hyprland.getWorkspace(Hyprland.active.workspace.id);
    if (workspace)
        Revealed.value = workspace.hasfullscreen;
});
Hyprland.connect('fullscreen', (_, fullscreen) => Revealed.value = fullscreen);

export default props => Overlay({
    overlays: [
        RoundedCorner('topleft',  { className: 'corner' }),
        RoundedCorner('topright', { className: 'corner' }),
    ],

    child: Box({
        css: 'min-height: 1px',
        hexpand: true,
        vertical: true,
        children: [
            Revealer({
                transition: 'slide_down',
                setup: self => self.revealChild = true,

                properties: [['timeouts', []]],
                connections: [[Revealed, self => {
                    App.getWindow('bar').setCss(Revealed.value ? '' : wStyle);
                    App.getWindow('bg-gradient').visible = !Revealed.value;

                    if (Revealed.value) {
                        timeout(2000, () => {
                            if (Revealed.value)
                                self.revealChild = false;
                        });
                    }
                    else {
                        self.revealChild = true;
                    }
                }]],

                child: EventBox({
                    onHover: () => Hovering.value = true,
                    onHoverLost: self => {
                        Hovering.value = false;
                        if (Revealed.value) {
                            timeout(2000, () => {
                                if (!Hovering.value) {
                                    // Replace bar with transparent eventbox
                                    self.get_parent().get_parent().children[1].revealChild = true;
                                    self.get_parent().revealChild = false;
                                }
                            });
                        }
                    },
                    ...props,
                }),
            }),

            Revealer({
                connections: [[Revealed, self => {
                    if (Revealed.value) {
                        timeout(2000, () => {
                            if (Revealed.value)
                                self.revealChild = true;
                        });
                    }
                    else {
                        self.revealChild = false;
                    }
                }]],
                child: EventBox({
                    onHover: self => {
                        Hovering.value = true;

                        // Replace eventbox with bar
                        self.get_parent().get_parent().children[0].revealChild = true;
                        self.get_parent().revealChild = false;
                    },
                    child: Box({
                        css: 'min-height: 5px;',
                    }),
                }),
            }),
        ],
    }),
});

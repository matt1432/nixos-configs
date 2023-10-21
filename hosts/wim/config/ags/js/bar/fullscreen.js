import { Widget, Hyprland, Utils, Variable } from '../../imports.js';
const { Box, EventBox, Overlay } = Widget;

const Revealed = Variable(true);
const Hovering = Variable(false);

import { RoundedCorner } from '../screen-corners.js';
import Gesture           from './gesture.js';


// TODO: add fullscreen status in hyprland.ts
// TODO: when fullscreen changes, keep current workspace in memory.
//       if it changes while still in fullscreen, check directly
//       with hyprctl if in fullscreen or not until fullscreen
//       status changes again

export default props => Overlay({
    overlays: [
        RoundedCorner('topleft',  { className: 'corner' }),
        RoundedCorner('topright', { className: 'corner' }),
    ],

    child: Box({
        style: 'min-height: 1px',
        hexpand: true,
        vertical: true,
        children: [
            Widget.Revealer({
                transition: 'slide_down',
                setup: self => self.revealChild = true,

                properties: [['timeouts', []]],
                connections: [[Hyprland, self => {
                    Utils.execAsync('hyprctl activewindow -j').then(out => {
                        const client = JSON.parse(out);
                        if (client.fullscreen === Revealed.value)
                            return;

                        Revealed.value = client.fullscreen;

                        if (Revealed.value) {
                            Utils.timeout(2000, () => {
                                if (Revealed.value)
                                    self.revealChild = false;
                            });
                        }
                        else {
                            self.revealChild = true;
                        }
                    }).catch(print);
                }]],

                child: Gesture({
                    onHover: () => Hovering.value = true,
                    onHoverLost: self => {
                        Hovering.value = false;
                        if (Revealed.value) {
                            Utils.timeout(2000, () => {
                                if (!Hovering.value) {
                                    self.get_parent().get_parent().children[1].revealChild = true;
                                    self.get_parent().revealChild = false;
                                }
                            });
                        }
                    },
                    ...props,
                }),
            }),

            Widget.Revealer({
                connections: [[Revealed, self => {
                    if (Revealed.value) {
                        Utils.timeout(2000, () => {
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
                        self.get_parent().get_parent().children[0].revealChild = true;
                        self.get_parent().revealChild = false;
                    },
                    child: Box({
                        style: 'min-height: 50px;',
                    }),
                }),
            }),
        ],
    }),
});

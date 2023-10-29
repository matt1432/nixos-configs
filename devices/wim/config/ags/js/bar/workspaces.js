import { Hyprland, Utils, Widget } from '../../imports.js';
const { Box, Revealer } = Widget;
const { execAsync } = Utils;

import EventBox from '../misc/cursorbox.js';


const Workspace = ({ i } = {}) =>
    Revealer({
        transition: 'slide_right',
        properties: [['id', i]],

        child: EventBox({
            tooltipText: `${i}`,
            onPrimaryClickRelease: () => {
                execAsync(`hyprctl dispatch workspace ${i}`)
                    .catch(print);
            },
            child: Box({
                valign: 'center',
                className: 'button',
                connections: [[Hyprland, self => {
                    const occupied = Hyprland.getWorkspace(i)?.windows > 0;
                    self.toggleClassName('active', Hyprland.active.workspace.id === i);
                    self.toggleClassName('occupied', occupied);
                    self.toggleClassName('empty', !occupied);
                }]],
            }),
        }),
    });

export default () => Box({
    className: 'workspaces',
    children: [EventBox({
        child: Box({
            properties: [
                ['workspaces'],

                ['refresh', self => {
                    self.children.forEach(rev => rev.reveal_child = false);
                    self._workspaces.forEach(ws => {
                        ws.revealChild = true;
                    });
                }],

                ['updateWs', self => {
                    Hyprland.workspaces.forEach(ws => {
                        const currentWs = self.children.find(ch => ch._id == ws.id);
                        if (!currentWs && ws.id > 0)
                            self.add(Workspace({ i: ws.id }));
                    });
                    self.show_all();

                    // Make sure the order is correct
                    self._workspaces.forEach((workspace, i) => {
                        workspace.get_parent().reorder_child(workspace, i);
                    });
                }],
            ],
            connections: [[Hyprland, self => {
                self._workspaces = self.children.filter(ch => {
                    return Hyprland.workspaces.find(ws => ws.id == ch._id);
                }).sort((a, b) => a._id - b._id);

                self._updateWs(self);
                self._refresh(self);
            }]],
        }),
    })],
});

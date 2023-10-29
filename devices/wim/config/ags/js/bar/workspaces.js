import { Hyprland, Utils, Widget } from '../../imports.js';
const { Box, Overlay, Revealer } = Widget;
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
                    self.toggleClassName('occupied', occupied);
                    self.toggleClassName('empty', !occupied);
                }]],
            }),
        }),
    });

export default () => Overlay({
    setup: self => {
        self.set_overlay_pass_through(
            self.get_children()[1],
            true,
        );
    },
    overlays: [Box({
        valign: 'center',
        halign: 'start',
        className: 'button active',
        connections: [[Hyprland.active.workspace, self => {
            const currentId = Hyprland.active.workspace.id;
            const indicators = self.get_parent().get_children()[0].child.children;
            const currentIndex = indicators.findIndex(w => w._id == currentId);

            self.setStyle(`margin-left: ${16 + currentIndex * 30}px`);
        }]],
    })],
    child: EventBox({
        child: Box({
            className: 'workspaces',
            properties: [
                ['workspaces'],

                ['refresh', self => {
                    self.children.forEach(rev => rev.reveal_child = false);
                    self._workspaces.forEach(ws => {
                        ws.revealChild = true;
                    });
                }],

                ['updateWorkspaces', self => {
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

                self._updateWorkspaces(self);
                self._refresh(self);
            }]],
        }),
    }),
});

import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import { timeout } from 'resource:///com/github/Aylur/ags/utils.js';
import { Box, Overlay, Revealer } from 'resource:///com/github/Aylur/ags/widget.js';

import EventBox from '../misc/cursorbox.js';


const Workspace = ({ i } = {}) =>
    Revealer({
        transition: 'slide_right',
        properties: [['id', i]],

        child: EventBox({
            tooltipText: `${i}`,
            onPrimaryClickRelease: () => Hyprland.sendMessage(`dispatch workspace ${i}`),
            child: Box({
                vpack: 'center',
                className: 'button',
                setup: self => {
                    self.update = addr => {
                        const occupied = Hyprland.getWorkspace(i)?.windows > 0;
                        self.toggleClassName('occupied', occupied);
                        self.toggleClassName('empty', !occupied);

                        // Deal with urgent windows
                        if (Hyprland.getClient(addr)?.workspace.id === i) {
                            self.toggleClassName('urgent', true);

                            // Only show for a sec when urgent is current workspace
                            if (Hyprland.active.workspace.id === i)
                                timeout(1000, () => self.toggleClassName('urgent', false));
                        }
                    };
                },
                connections: [
                    [Hyprland, self => self.update()],

                    // Deal with urgent windows
                    [Hyprland, (self, addr) => self.update(addr), 'urgent-window'],
                    [Hyprland.active.workspace, self => {
                        if (Hyprland.active.workspace.id === i)
                            self.toggleClassName('urgent', false);
                    }],
                ],
            }),
        }),
    });

export default () => {
    const updateHighlight = () => {
        const currentId = Hyprland.active.workspace.id;
        const indicators = highlight.get_parent().get_children()[0].child.children;
        const currentIndex = indicators.findIndex(w => w._id == currentId);

        if (currentIndex < 0)
            return;

        highlight.setCss(`margin-left: ${16 + currentIndex * 30}px`);
    };
    const highlight = Box({
        vpack: 'center',
        hpack: 'start',
        className: 'button active',
        connections: [[Hyprland.active.workspace, updateHighlight]],
    });

    const widget = Overlay({
        pass_through: true,
        overlays: [highlight],
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

                    // Make sure the highlight doesn't go too far
                    timeout(10, updateHighlight);
                }]],
            }),
        }),
    });

    return widget;
};

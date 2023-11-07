import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import { Box } from 'resource:///com/github/Aylur/ags/widget.js';
import * as VARS from './variables.js';

const DEFAULT_STYLE = `
    min-width:  ${VARS.SCREEN.X * VARS.SCALE}px;
    min-height: ${VARS.SCREEN.Y * VARS.SCALE - 4}px;
    border-radius: 10px;
`;


export const Highlighter = () => Box({
    vpack: 'start',
    hpack: 'start',
    className: 'workspace active',
    css: DEFAULT_STYLE,
});

export const updateCurrentWorkspace = (main, highlighter) => {
    const currentId = Hyprland.active.workspace.id;
    const row = Math.floor((currentId - 1) / VARS.WORKSPACE_PER_ROW);

    const rowObject = main.children[0].children[row];
    const workspaces = rowObject.child.centerWidget.child.get_children().filter(w => w.revealChild);

    const height = row * (VARS.SCREEN.Y * VARS.SCALE + 17);
    const currentIndex = workspaces.findIndex(w => w._id == currentId);

    highlighter.setCss(`
        ${DEFAULT_STYLE}
        margin-left: ${9 + currentIndex * (VARS.SCREEN.X * VARS.SCALE + 34)}px;
        margin-top: ${9 + height}px;
    `);
};

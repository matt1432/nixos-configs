import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

import { Box } from 'resource:///com/github/Aylur/ags/widget.js';
import * as VARS from './variables.js';

const PADDING = 34;
const MARGIN = 9;
const DEFAULT_STYLE = `
    min-width:  ${VARS.SCREEN.X * VARS.SCALE}px;
    min-height: ${(VARS.SCREEN.Y * VARS.SCALE) - (VARS.MARGIN / 2)}px;
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
    const workspaces = rowObject.child.centerWidget.child
        .get_children().filter((w) => w.revealChild);

    const currentIndex = workspaces.findIndex((w) => w._id === currentId);
    const left = currentIndex * ((VARS.SCREEN.X * VARS.SCALE) + PADDING);
    const height = row * ((VARS.SCREEN.Y * VARS.SCALE) + (PADDING / 2));

    highlighter.setCss(`
        ${DEFAULT_STYLE}
        margin-left: ${MARGIN + left}px;
        margin-top: ${MARGIN + height}px;
    `);
};

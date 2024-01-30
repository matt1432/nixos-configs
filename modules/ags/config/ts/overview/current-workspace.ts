const Hyprland = await Service.import('hyprland');

const { Box } = Widget;

import * as VARS from './variables.ts';

const PADDING = 34;
const MARGIN = 9;
const DEFAULT_STYLE = `
    min-width:  ${VARS.SCREEN.X * VARS.SCALE}px;
    min-height: ${(VARS.SCREEN.Y * VARS.SCALE) - (VARS.MARGIN / 2)}px;
    border-radius: 10px;
`;

// Types
import AgsBox from 'types/widgets/box.ts';
import AgsRevealer from 'types/widgets/revealer.ts';
import AgsCenterBox from 'types/widgets/centerbox.ts';
import AgsEventBox from 'types/widgets/eventbox.ts';


export const Highlighter = () => Box({
    vpack: 'start',
    hpack: 'start',
    class_name: 'workspace active',
    css: DEFAULT_STYLE,
});

export const updateCurrentWorkspace = (main: AgsBox, highlighter: AgsBox) => {
    const currentId = Hyprland.active.workspace.id;
    const row = Math.floor((currentId - 1) / VARS.WORKSPACE_PER_ROW);

    const rowObject = (main.children[0] as AgsBox).children[row] as AgsRevealer;
    const workspaces = ((((rowObject.child as AgsCenterBox)
        .center_widget as AgsEventBox)
        .child as AgsBox)
        .get_children() as Array<AgsRevealer>)
        .filter((w) => w.reveal_child);

    const currentIndex = workspaces.findIndex(
        (w) => w.attribute.id === currentId,
    );
    const left = currentIndex * ((VARS.SCREEN.X * VARS.SCALE) + 2 + PADDING);
    const height = row * ((VARS.SCREEN.Y * VARS.SCALE) + (PADDING / 2));

    highlighter.setCss(`
        ${DEFAULT_STYLE}
        margin-left: ${MARGIN + left}px;
        margin-top: ${MARGIN + height}px;
    `);
};

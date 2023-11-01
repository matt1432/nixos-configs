import { timeout } from 'resource:///com/github/Aylur/ags/utils.js';
import { Box, EventBox, Overlay } from 'resource:///com/github/Aylur/ags/widget.js';

import Gtk from 'gi://Gtk';

const MAX_OFFSET = 200;
const OFFSCREEN = 500;
const TRANSITION = 'transition: margin 0.5s ease, opacity 3s ease;';


export default ({
    properties,
    connections,
    props,
} = {}) => {
    const widget = EventBox({});
    const gesture = Gtk.GestureDrag.new(widget);

    widget.add(Overlay({
        ...props,
        properties: [
            ...properties,
            ['dragging', false],
        ],
        child: Box({ className: 'player' }),
        connections: [
            ...connections,

            [gesture, overlay => {
                if (overlay.list().length <= 1)
                    return;

                overlay._dragging = true;
                const offset = gesture.get_offset()[1];

                const playerBox = overlay.list().at(-1);

                if (offset >= 0) {
                    playerBox.setStyle(`
                        margin-left:   ${offset}px;
                        margin-right: -${offset}px;
                        ${playerBox._bgStyle}
                    `);
                }
                else {
                    const newOffset = Math.abs(offset);
                    playerBox.setStyle(`
                        margin-left: -${newOffset}px;
                        margin-right: ${newOffset}px;
                        ${playerBox._bgStyle}
                    `);
                }
                overlay._selected = playerBox;
            }, 'drag-update'],

            [gesture, overlay => {
                if (overlay.list().length <= 1)
                    return;

                overlay._dragging = false;
                const offset = gesture.get_offset()[1];

                const playerBox = overlay.list().at(-1);

                if (Math.abs(offset) > MAX_OFFSET) {
                    widget.sensitive = false;
                    if (offset >= 0) {
                        playerBox.setStyle(`
                            ${TRANSITION}
                            margin-left:   ${OFFSCREEN}px;
                            margin-right: -${OFFSCREEN}px;
                            opacity: 0; ${playerBox._bgStyle}
                        `);
                    }
                    else {
                        playerBox.setStyle(`
                            ${TRANSITION}
                            margin-left: -${OFFSCREEN}px;
                            margin-right: ${OFFSCREEN}px;
                            opacity: 0; ${playerBox._bgStyle}`);
                    }
                    timeout(500, () => {
                        overlay.reorder_overlay(playerBox, 0);
                        playerBox.setStyle(playerBox._bgStyle);
                        overlay._selected = overlay.list().at(-1);
                        widget.sensitive = true;
                    });
                }
                else {
                    playerBox.setStyle(`${TRANSITION} ${playerBox._bgStyle}`);
                }
            }, 'drag-end'],
        ],
    }));
    widget.child.list = () => widget.child.get_children().filter(ch => ch._bgStyle !== undefined);

    return widget;
};

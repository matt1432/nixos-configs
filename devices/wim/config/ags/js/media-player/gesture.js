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

        // Have empty PlayerBox to define the size of the widget
        child: Box({ className: 'player' }),
        connections: [
            ...connections,

            [gesture, overlay => {
                // Don't allow gesture when only one player
                if (overlay.list().length <= 1)
                    return;

                overlay._dragging = true;
                var offset = gesture.get_offset()[1];

                const playerBox = overlay.list().at(-1);

                // Sliding right
                if (offset >= 0) {
                    playerBox.setStyle(`
                        margin-left:   ${offset}px;
                        margin-right: -${offset}px;
                        ${playerBox._bgStyle}
                    `);
                }

                // Sliding left
                else {
                    offset = Math.abs(offset);
                    playerBox.setStyle(`
                        margin-left: -${offset}px;
                        margin-right: ${offset}px;
                        ${playerBox._bgStyle}
                    `);
                }
            }, 'drag-update'],

            [gesture, overlay => {
                // Don't allow gesture when only one player
                if (overlay.list().length <= 1)
                    return;

                overlay._dragging = false;
                const offset = gesture.get_offset()[1];

                const playerBox = overlay.list().at(-1);

                // If crosses threshold after letting go, slide away
                if (Math.abs(offset) > MAX_OFFSET) {
                    // Disable inputs during animation
                    widget.sensitive = false;

                    // Slide away right
                    if (offset >= 0) {
                        playerBox.setStyle(`
                            ${TRANSITION}
                            margin-left:   ${OFFSCREEN}px;
                            margin-right: -${OFFSCREEN}px;
                            opacity: 0; ${playerBox._bgStyle}
                        `);
                    }

                    // Slide away left
                    else {
                        playerBox.setStyle(`
                            ${TRANSITION}
                            margin-left: -${OFFSCREEN}px;
                            margin-right: ${OFFSCREEN}px;
                            opacity: 0; ${playerBox._bgStyle}`);
                    }

                    timeout(500, () => {
                        // Put the player in the back after anim
                        overlay.reorder_overlay(playerBox, 0);
                        // Recenter player
                        playerBox.setStyle(playerBox._bgStyle);

                        widget.sensitive = true;
                    });
                }
                else {
                    // Recenter with transition for animation
                    playerBox.setStyle(`${TRANSITION} ${playerBox._bgStyle}`);
                }
            }, 'drag-end'],
        ],
    }));
    widget.child.list = () => widget.child.get_children().filter(ch => ch._bgStyle !== undefined);

    return widget;
};

import { timeout } from 'resource:///com/github/Aylur/ags/utils.js';
import { Box, EventBox, Overlay } from 'resource:///com/github/Aylur/ags/widget.js';

import Gtk from 'gi://Gtk';

const MAX_OFFSET = 200;
const OFFSCREEN = 500;
const ANIM_DURATION = 500;
const TRANSITION = `transition: margin ${ANIM_DURATION}ms ease,
                                opacity ${ANIM_DURATION}ms ease;`;


export default ({
    properties,
    connections,
    props,
} = {}) => {
    const widget = EventBox();
    const gesture = Gtk.GestureDrag.new(widget);

    // Have empty PlayerBox to define the size of the widget
    const emptyPlayer = Box({ className: 'player' });

    // Set this prop to differentiate it easily
    emptyPlayer.empty = true;

    const content = Overlay({
        ...props,
        properties: [
            ...properties,
            ['dragging', false],
        ],

        child: emptyPlayer,

        connections: [
            ...connections,

            [gesture, (overlay, realGesture) => {
                if (realGesture) {
                    overlay.list().forEach((over) => {
                        over.visible = true;
                    });
                }
                else {
                    overlay.showTopOnly();
                }

                // Don't allow gesture when only one player
                if (overlay.list().length <= 1) {
                    return;
                }

                overlay._dragging = true;
                let offset = gesture.get_offset()[1];

                const playerBox = overlay.list().at(-1);

                // Slide right
                if (offset >= 0) {
                    playerBox.setCss(`
                        margin-left:   ${offset}px;
                        margin-right: -${offset}px;
                        ${playerBox._bgStyle}
                    `);
                }

                // Slide left
                else {
                    offset = Math.abs(offset);
                    playerBox.setCss(`
                        margin-left: -${offset}px;
                        margin-right: ${offset}px;
                        ${playerBox._bgStyle}
                    `);
                }
            }, 'drag-update'],

            [gesture, (overlay) => {
                // Don't allow gesture when only one player
                if (overlay.list().length <= 1) {
                    return;
                }

                overlay._dragging = false;
                const offset = gesture.get_offset()[1];

                const playerBox = overlay.list().at(-1);

                // If crosses threshold after letting go, slide away
                if (Math.abs(offset) > MAX_OFFSET) {
                    // Disable inputs during animation
                    widget.sensitive = false;

                    // Slide away right
                    if (offset >= 0) {
                        playerBox.setCss(`
                            ${TRANSITION}
                            margin-left:   ${OFFSCREEN}px;
                            margin-right: -${OFFSCREEN}px;
                            opacity: 0; ${playerBox._bgStyle}
                        `);
                    }

                    // Slide away left
                    else {
                        playerBox.setCss(`
                            ${TRANSITION}
                            margin-left: -${OFFSCREEN}px;
                            margin-right: ${OFFSCREEN}px;
                            opacity: 0; ${playerBox._bgStyle}`);
                    }

                    timeout(ANIM_DURATION, () => {
                        // Put the player in the back after anim
                        overlay.reorder_overlay(playerBox, 0);
                        // Recenter player
                        playerBox.setCss(playerBox._bgStyle);

                        widget.sensitive = true;

                        overlay.showTopOnly();
                    });
                }
                else {
                    // Recenter with transition for animation
                    playerBox.setCss(`${TRANSITION} ${playerBox._bgStyle}`);
                }
            }, 'drag-end'],
        ],
    });

    widget.add(content);

    // Overlay methods
    content.list = () => content.get_children()
        .filter((ch) => !ch.empty);

    content.includesWidget = (playerW) => {
        return content.list().find((w) => w === playerW);
    };

    content.showTopOnly = () => content.list().forEach((over) => {
        over.visible = over === content.list().at(-1);
    });

    content.moveToTop = (player) => {
        player.visible = true;
        content.reorder_overlay(player, -1);
        timeout(ANIM_DURATION, () => {
            content.showTopOnly();
        });
    };

    widget.getOverlay = () => content;

    return widget;
};

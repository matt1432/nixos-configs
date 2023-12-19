import { timeout } from 'resource:///com/github/Aylur/ags/utils.js';
import { Box, EventBox, Overlay } from 'resource:///com/github/Aylur/ags/widget.js';

const { Gtk } = imports.gi;

const MAX_OFFSET = 200;
const OFFSCREEN = 500;
const ANIM_DURATION = 500;
const TRANSITION = `transition: margin ${ANIM_DURATION}ms ease,
                                opacity ${ANIM_DURATION}ms ease;`;


export default ({
    attribute = {},
    setup = (self) => {
        self;
    },
    ...props
}) => {
    const widget = EventBox();
    const gesture = Gtk.GestureDrag.new(widget);

    // Have empty PlayerBox to define the size of the widget
    const emptyPlayer = Box({
        class_name: 'player',
        attribute: { empty: true },
    });

    const content = Overlay({
        ...props,
        attribute: {
            ...attribute,
            dragging: false,

            list: () => content.get_children()
                // @ts-expect-error
                .filter((ch) => !ch.attribute?.empty),

            includesWidget: (playerW) => {
                return Array.from(content.attribute.list())
                    .find((w) => w === playerW);
            },

            showTopOnly: () => Array.from(content.attribute.list())
                .forEach((over) => {
                    over.visible = over === content.attribute.list().at(-1);
                }),

            moveToTop: (player) => {
                player.visible = true;
                content.reorder_overlay(player, -1);
                timeout(ANIM_DURATION, () => {
                    content.attribute.showTopOnly();
                });
            },
        },

        child: emptyPlayer,

        setup: (self) => {
            setup(self);

            self
                .hook(gesture, (overlay, realGesture) => {
                    if (realGesture) {
                        Array.from(overlay.attribute.list()).forEach((over) => {
                            over.visible = true;
                        });
                    }
                    else {
                        overlay.attribute.showTopOnly();
                    }

                    // Don't allow gesture when only one player
                    if (overlay.attribute.list().length <= 1) {
                        return;
                    }

                    overlay.attribute.dragging = true;
                    let offset = gesture.get_offset()[1];
                    const playerBox = overlay.attribute.list().at(-1);

                    if (!offset) {
                        return;
                    }

                    // Slide right
                    if (offset >= 0) {
                        playerBox.setCss(`
                            margin-left:   ${offset}px;
                            margin-right: -${offset}px;
                            ${playerBox.attribute.bgStyle}
                        `);
                    }

                    // Slide left
                    else {
                        offset = Math.abs(offset);
                        playerBox.setCss(`
                            margin-left: -${offset}px;
                            margin-right: ${offset}px;
                            ${playerBox.attribute.bgStyle}
                        `);
                    }
                }, 'drag-update')

                .hook(gesture, (overlay) => {
                    // Don't allow gesture when only one player
                    if (overlay.attribute.list().length <= 1) {
                        return;
                    }

                    overlay.attribute.dragging = false;
                    const offset = gesture.get_offset()[1];

                    const playerBox = overlay.attribute.list().at(-1);

                    // If crosses threshold after letting go, slide away
                    if (offset && Math.abs(offset) > MAX_OFFSET) {
                        // Disable inputs during animation
                        widget.sensitive = false;

                        // Slide away right
                        if (offset >= 0) {
                            playerBox.setCss(`
                                ${TRANSITION}
                                margin-left:   ${OFFSCREEN}px;
                                margin-right: -${OFFSCREEN}px;
                                opacity: 0.7; ${playerBox.attribute.bgStyle}
                            `);
                        }

                        // Slide away left
                        else {
                            playerBox.setCss(`
                                ${TRANSITION}
                                margin-left: -${OFFSCREEN}px;
                                margin-right: ${OFFSCREEN}px;
                                opacity: 0.7; ${playerBox.attribute.bgStyle}
                            `);
                        }

                        timeout(ANIM_DURATION, () => {
                            // Put the player in the back after anim
                            overlay.reorder_overlay(playerBox, 0);
                            // Recenter player
                            playerBox.setCss(playerBox.attribute.bgStyle);

                            widget.sensitive = true;

                            overlay.attribute.showTopOnly();
                        });
                    }
                    else {
                        // Recenter with transition for animation
                        playerBox.setCss(`${TRANSITION}
                            ${playerBox.attribute.bgStyle}`);
                    }
                }, 'drag-end');
        },
    });

    widget.add(content);

    return widget;
};

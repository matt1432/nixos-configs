const { timeout } = Utils;
const { Box, EventBox, Overlay } = Widget;

const { Gtk } = imports.gi;

const MAX_OFFSET = 200;
const OFFSCREEN = 500;
const ANIM_DURATION = 500;
const TRANSITION = `transition: margin ${ANIM_DURATION}ms ease,
                                opacity ${ANIM_DURATION}ms ease;`;

// Types
import {
    CenterBoxGeneric,
    Gesture,
    OverlayGeneric,
    PlayerBox,
} from 'global-types';


export default ({
    setup = () => { /**/ },
    ...props
}: Gesture) => {
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
            players: new Map(),
            setup: false,
            dragging: false,

            includesWidget: (playerW: OverlayGeneric) => {
                return content.overlays.find((w) => w === playerW);
            },

            showTopOnly: () => content.overlays.forEach((over) => {
                over.visible = over === content.overlays.at(-1);
            }),

            moveToTop: (player: CenterBoxGeneric) => {
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
                .hook(gesture, (_, realGesture) => {
                    if (realGesture) {
                        self.overlays.forEach((over) => {
                            over.visible = true;
                        });
                    }
                    else {
                        self.attribute.showTopOnly();
                    }

                    // Don't allow gesture when only one player
                    if (self.overlays.length <= 1) {
                        return;
                    }

                    self.attribute.dragging = true;
                    let offset = gesture.get_offset()[1];
                    const playerBox = self.overlays.at(-1) as PlayerBox;

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


                .hook(gesture, () => {
                    // Don't allow gesture when only one player
                    if (self.overlays.length <= 1) {
                        return;
                    }

                    self.attribute.dragging = false;
                    const offset = gesture.get_offset()[1];

                    const playerBox = self.overlays.at(-1) as PlayerBox;

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
                            self.reorder_overlay(playerBox, 0);
                            // Recenter player
                            playerBox.setCss(playerBox.attribute.bgStyle);

                            widget.sensitive = true;

                            self.attribute.showTopOnly();
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

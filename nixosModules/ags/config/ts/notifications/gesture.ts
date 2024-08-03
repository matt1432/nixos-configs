const Notifications = await Service.import('notifications');

const { Box, EventBox } = Widget;
const { timeout } = Utils;

import { HasNotifs } from './base.ts';

const { Gdk, Gtk } = imports.gi;
const display = Gdk.Display.get_default();

// Types
import { BoxGeneric } from 'global-types';

const MAX_OFFSET = 200;
const OFFSCREEN = 300;
const ANIM_DURATION = 500;
const SLIDE_MIN_THRESHOLD = 10;
const TRANSITION = 'transition: margin 0.5s ease, opacity 0.5s ease;';
const SQUEEZED = 'margin-bottom: -70px; margin-top: -70px;';
const MAX_LEFT = `
    margin-left: -${Number(MAX_OFFSET + OFFSCREEN)}px;
    margin-right: ${Number(MAX_OFFSET + OFFSCREEN)}px;
`;
const MAX_RIGHT = `
    margin-left:   ${Number(MAX_OFFSET + OFFSCREEN)}px;
    margin-right: -${Number(MAX_OFFSET + OFFSCREEN)}px;
`;

const slideLeft = `${TRANSITION} ${MAX_LEFT}
                        margin-top: 0px;
                        margin-bottom: 0px;
                        opacity: 0;`;
const squeezeLeft = `${TRANSITION} ${MAX_LEFT} ${SQUEEZED} opacity: 0;`;

const slideRight = `${TRANSITION} ${MAX_RIGHT}
                        margin-top: 0px;
                        margin-bottom: 0px;
                        opacity: 0;`;
const squeezeRight = `${TRANSITION} ${MAX_RIGHT} ${SQUEEZED} opacity: 0;`;

const defaultStyle = `${TRANSITION} margin: unset; opacity: 1;`;


export default ({
    id,
    slideIn = 'Left',
    command = () => { /**/ },
    ...props
}) => {
    const widget = EventBox({
        ...props,

        setup: (self) => {
            self
                // OnClick
                .on('button-press-event', () => {
                    if (!display) {
                        return;
                    }
                    self.window.set_cursor(Gdk.Cursor.new_from_name(
                        display,
                        'grabbing',
                    ));
                })

                // OnRelease
                .on('button-release-event', () => {
                    if (!display) {
                        return;
                    }
                    self.window.set_cursor(Gdk.Cursor.new_from_name(
                        display,
                        'grab',
                    ));
                })

                // OnHover
                .on('enter-notify-event', () => {
                    if (!display) {
                        return;
                    }
                    self.window.set_cursor(Gdk.Cursor.new_from_name(
                        display,
                        'grab',
                    ));
                    self.toggleClassName('hover', true);
                    if (!self.attribute.hovered) {
                        self.attribute.hovered = true;
                    }
                })

                // OnHoverLost
                .on('leave-notify-event', () => {
                    self.window.set_cursor(null);
                    self.toggleClassName('hover', false);

                    if (self.attribute.hovered) {
                        self.attribute.hovered = false;
                    }
                });
        },

        attribute: {
            dragging: false,
            hovered: false,
            ready: false,
            id,

            slideAway: (side: 'Left' | 'Right') => {
                (widget.child as BoxGeneric)
                    .setCss(side === 'Left' ? slideLeft : slideRight);

                // Make it uninteractable
                widget.sensitive = false;

                timeout(ANIM_DURATION - 100, () => {
                    // Reduce height after sliding away
                    (widget.child as BoxGeneric)?.setCss(side === 'Left' ?
                        squeezeLeft :
                        squeezeRight);

                    timeout(ANIM_DURATION, () => {
                        // Kill notif and update HasNotifs after anim is done
                        command();

                        HasNotifs.setValue(Notifications
                            .notifications.length > 0);

                        (widget.get_parent() as BoxGeneric)?.remove(widget);
                    });
                });
            },
        },
    });

    const gesture = Gtk.GestureDrag.new(widget);

    widget.add(Box({
        css: squeezeLeft,
        setup: (self) => {
            self
                // When dragging
                .hook(gesture, () => {
                    let offset = gesture.get_offset()[1];

                    if (!offset || offset === 0) {
                        return;
                    }

                    // Slide right
                    if (offset > 0) {
                        self.setCss(`
                        margin-top: 0px; margin-bottom: 0px;
                        opacity: 1; transition: none;
                        margin-left:   ${offset}px;
                        margin-right: -${offset}px;
                    `);
                    }

                    // Slide left
                    else {
                        offset = Math.abs(offset);
                        self.setCss(`
                        margin-top: 0px; margin-bottom: 0px;
                        opacity: 1; transition: none;
                        margin-right: ${offset}px;
                        margin-left: -${offset}px;
                    `);
                    }

                    // Put a threshold on if a click is actually dragging
                    widget.attribute.dragging =
                        Math.abs(offset) > SLIDE_MIN_THRESHOLD;

                    widget.cursor = 'grabbing';
                }, 'drag-update')

                // On drag end
                .hook(gesture, () => {
                    // Make it slide in on init
                    if (!widget.attribute.ready) {
                        // Reverse of slideAway, so it started at squeeze, then we go to slide
                        self.setCss(slideIn === 'Left' ?
                            slideLeft :
                            slideRight);

                        timeout(ANIM_DURATION, () => {
                            // Then we go to center
                            self.setCss(defaultStyle);
                            timeout(ANIM_DURATION, () => {
                                widget.attribute.ready = true;
                            });
                        });

                        return;
                    }

                    const offset = gesture.get_offset()[1];

                    if (!offset) {
                        return;
                    }

                    // If crosses threshold after letting go, slide away
                    if (Math.abs(offset) > MAX_OFFSET) {
                        if (offset > 0) {
                            widget.attribute.slideAway('Right');
                        }
                        else {
                            widget.attribute.slideAway('Left');
                        }
                    }
                    else {
                        self.setCss(defaultStyle);
                        widget.cursor = 'grab';
                        widget.attribute.dragging = false;
                    }
                }, 'drag-end');
        },
    }));

    return widget;
};

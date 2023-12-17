import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';

import { Box, EventBox } from 'resource:///com/github/Aylur/ags/widget.js';
import { timeout } from 'resource:///com/github/Aylur/ags/utils.js';

import { HasNotifs } from './base.js';

import Gtk from 'gi://Gtk';

const MAX_OFFSET = 200;
const OFFSCREEN = 300;
const ANIM_DURATION = 500;
const SLIDE_MIN_THRESHOLD = 10;


export default ({
    id,
    slideIn = 'Left',
    command = () => { /**/ },
    ...props
}) => {
    const widget = EventBox({
        ...props,
        cursor: 'grab',
        onHover: (self) => {
            if (!self._hovered) {
                self._hovered = true;
            }
        },
        onHoverLost: (self) => {
            if (self._hovered) {
                self._hovered = false;
            }
        },
    });

    // Properties
    widget._dragging = false;
    widget._hovered = false;
    widget._id = id;
    widget.ready = false;

    const gesture = Gtk.GestureDrag.new(widget);

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


    // Notif methods
    widget.slideAway = (side) => {
        // Slide away
        widget.child.setCss(side === 'Left' ? slideLeft : slideRight);

        // Makie it uninteractable
        widget.sensitive = false;

        timeout(ANIM_DURATION - 100, () => {
            // Reduce height after sliding away
            widget.child?.setCss(side === 'Left' ? squeezeLeft : squeezeRight);

            timeout(ANIM_DURATION, () => {
                // Kill notif and update HasNotifs after anim is done
                command();
                HasNotifs.value = Notifications.notifications.length > 0;
                widget.get_parent()?.remove(widget);
            });
        });
    };

    widget.add(Box({
        css: squeezeLeft,
        setup: (self) => {
            self
                // When dragging
                .hook(gesture, () => {
                    let offset = gesture.get_offset()[1];

                    if (offset === 0) {
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
                    widget._dragging = Math.abs(offset) > SLIDE_MIN_THRESHOLD;
                    widget.cursor = 'grabbing';
                }, 'drag-update')

                // On drag end
                .hook(gesture, () => {
                    // Make it slide in on init
                    if (!widget.ready) {
                        // Reverse of slideAway, so it started at squeeze, then we go to slide
                        self.setCss(slideIn === 'Left' ?
                            slideLeft :
                            slideRight);

                        timeout(ANIM_DURATION, () => {
                            // Then we go to center
                            self.setCss(defaultStyle);
                            timeout(ANIM_DURATION, () => {
                                widget.ready = true;
                            });
                        });

                        return;
                    }

                    const offset = gesture.get_offset()[1];

                    // If crosses threshold after letting go, slide away
                    if (Math.abs(offset) > MAX_OFFSET) {
                        if (offset > 0) {
                            widget.slideAway('Right');
                        }
                        else {
                            widget.slideAway('Left');
                        }
                    }
                    else {
                        self.setCss(defaultStyle);
                        widget.cursor = 'grab';
                        widget._dragging = false;
                    }
                }, 'drag-end');
        },
    }));

    return widget;
};

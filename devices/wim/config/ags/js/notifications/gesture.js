import { Box, EventBox } from 'resource:///com/github/Aylur/ags/widget.js';
import { timeout } from 'resource:///com/github/Aylur/ags/utils.js';

import Gtk from 'gi://Gtk';
import Gdk from 'gi://Gdk';
const display = Gdk.Display.get_default();


export default ({
    slideIn = 'Left',
    maxOffset = 150,
    startMargin = 0,
    endMargin = 300,
    command = () => {},
    onHover = () => {},
    onHoverLost = () => {},
    child = '',
    children = [],
    properties = [[]],
    ...props
}) => {
    const widget = EventBox({
        ...props,
        properties: [
            ['dragging', false],
            ...properties,
        ],
        onHover: self => {
            self.window.set_cursor(Gdk.Cursor.new_from_name(display, 'grab'));
            onHover(self);
        },
        onHoverLost: self => {
            self.window.set_cursor(null);
            onHoverLost(self);
        },
    });

    const gesture = Gtk.GestureDrag.new(widget);

    const TRANSITION = 'transition: margin 0.5s ease, opacity 0.5s ease;';
    const SQUEEZED = 'margin-bottom: -70px; margin-top: -70px;';
    const MAX_LEFT = `
        margin-left: -${Number(maxOffset + endMargin)}px;
        margin-right: ${Number(maxOffset + endMargin)}px;
    `;
    const MAX_RIGHT = `
        margin-left:   ${Number(maxOffset + endMargin)}px;
        margin-right: -${Number(maxOffset + endMargin)}px;
    `;

    const slideLeft    = `${TRANSITION} ${MAX_LEFT} opacity: 0;`;
    const squeezeLeft  = `${TRANSITION} ${MAX_LEFT} ${SQUEEZED} opacity: 0;`;
    const slideRight   = `${TRANSITION} ${MAX_RIGHT} opacity: 0;`;
    const squeezeRight = `${TRANSITION} ${MAX_RIGHT} ${SQUEEZED} opacity: 0;`;

    widget.add(Box({
        properties: [
            ['slideLeft',    slideLeft],
            ['squeezeLeft',  squeezeLeft],
            ['slideRight',   slideRight],
            ['squeezeRight', squeezeRight],
            ['ready', false],
        ],
        children: [
            ...children,
            child,
        ],
        style: squeezeLeft,
        connections: [

            [gesture, self => {
                var offset = gesture.get_offset()[1];

                // Slide right
                if (offset >= 0) {
                    self.setStyle(`
                        margin-left:   ${Number(offset + startMargin)}px;
                        margin-right: -${Number(offset + startMargin)}px;
                    `);
                }

                // Slide left
                else {
                    offset = Math.abs(offset);
                    self.setStyle(`
                        margin-right: ${Number(offset + startMargin)}px;
                        margin-left: -${Number(offset + startMargin)}px;
                    `);
                }

                // Put a threshold on if a click is actually dragging
                self.get_parent()._dragging = Math.abs(offset) > 10;

                if (widget.window)
                    widget.window.set_cursor(Gdk.Cursor.new_from_name(display, 'grabbing'));
            }, 'drag-update'],

            [gesture, self => {
                // Make it slide in on init
                if (!self._ready) {
                    self.setStyle(slideIn === 'Left' ? slideLeft : slideRight);

                    timeout(500, () => self.setStyle(`${TRANSITION} margin: unset; opacity: 1;`));
                    timeout(1000, () => self._ready = true);
                    return;
                }

                const offset = gesture.get_offset()[1];

                // If crosses threshold after letting go, slide away
                if (Math.abs(offset) > maxOffset) {
                    // Slide away right
                    if (offset > 0) {
                        // Disable inputs during animation
                        widget.sensitive = false;

                        self.setStyle(slideRight);
                        timeout(500, () => self.setStyle(squeezeRight));
                    }

                    // Slide away left
                    else {
                        // Disable inputs during animation
                        widget.sensitive = false;

                        self.setStyle(slideLeft);
                        timeout(500, () => self.setStyle(squeezeLeft));
                    }

                    timeout(1000, () => {
                        command();
                        self.destroy();
                    });
                }
                else {
                    self.setStyle(`${TRANSITION} margin: unset; opacity: 1;`);
                    if (widget.window)
                        widget.window.set_cursor(Gdk.Cursor.new_from_name(display, 'grab'));

                    self.get_parent()._dragging = false;
                }
            }, 'drag-end'],

        ],
    }));

    return widget;
};

import { Utils, Widget } from '../../imports.js';
const { Box, EventBox } = Widget;

import Gtk from 'gi://Gtk';
import Gdk from 'gi://Gdk';
const display = Gdk.Display.get_default();


export default ({
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

    const leftAnim1 = `transition: margin 0.5s ease, opacity 0.5s ease;
                       margin-left: -${Number(maxOffset + endMargin)}px;
                       margin-right: ${Number(maxOffset + endMargin)}px;
                       opacity: 0;`;

    const leftAnim2 = `transition: margin 0.5s ease, opacity 0.5s ease;
                       margin-left: -${Number(maxOffset + endMargin)}px;
                       margin-right: ${Number(maxOffset + endMargin)}px;
                       margin-bottom: -70px; margin-top: -70px; opacity: 0;`;

    const rightAnim1 = `transition: margin 0.5s ease, opacity 0.5s ease;
                        margin-left:   ${Number(maxOffset + endMargin)}px;
                        margin-right: -${Number(maxOffset + endMargin)}px;
                        opacity: 0;`;

    const rightAnim2 = `transition: margin 0.5s ease, opacity 0.5s ease;
                        margin-left:   ${Number(maxOffset + endMargin)}px;
                        margin-right: -${Number(maxOffset + endMargin)}px;
                        margin-bottom: -70px; margin-top: -70px; opacity: 0;`;

    widget.add(Box({
        properties: [
            ['leftAnim1',  leftAnim1],
            ['leftAnim2',  leftAnim2],
            ['rightAnim1', rightAnim1],
            ['rightAnim2', rightAnim2],
            ['ready', false],
        ],
        children: [
            ...children,
            child,
        ],
        style: leftAnim2,
        connections: [

            [gesture, self => {
                var offset = gesture.get_offset()[1];

                if (offset >= 0) {
                    self.setStyle(`margin-left:   ${Number(offset + startMargin)}px;
                                   margin-right: -${Number(offset + startMargin)}px;`);
                }
                else {
                    offset = Math.abs(offset);
                    self.setStyle(`margin-right: ${Number(offset + startMargin)}px;
                                   margin-left: -${Number(offset + startMargin)}px;`);
                }

                self.get_parent()._dragging = Math.abs(offset) > 10;

                if (widget.window)
                    widget.window.set_cursor(Gdk.Cursor.new_from_name(display, 'grabbing'));
            }, 'drag-update'],

            [gesture, self => {
                if (!self._ready) {
                    self.setStyle(`transition: margin 0.5s ease, opacity 0.5s ease;
                                   margin-left: -${Number(maxOffset + endMargin)}px;
                                   margin-right: ${Number(maxOffset + endMargin)}px;
                                   margin-bottom: 0px; margin-top: 0px; opacity: 0;`);

                    Utils.timeout(500, () => {
                        self.setStyle(`transition: margin 0.5s ease, opacity 0.5s ease;
                                       margin-left:  ${startMargin}px;
                                       margin-right: ${startMargin}px;
                                       margin-bottom: unset; margin-top: unset;
                                       opacity: 1;`);
                    });
                    Utils.timeout(1000, () => self._ready = true);
                    return;
                }

                const offset = gesture.get_offset()[1];

                if (Math.abs(offset) > maxOffset) {
                    if (offset > 0) {
                        self.setStyle(rightAnim1);
                        widget.sensitive = false;
                        Utils.timeout(500, () => {
                            self.setStyle(rightAnim2);
                        });
                    }
                    else {
                        self.setStyle(leftAnim1);
                        widget.sensitive = false;
                        Utils.timeout(500, () => {
                            self.setStyle(leftAnim2);
                        });
                    }
                    Utils.timeout(1000, () => {
                        command();
                        self.destroy();
                    });
                }
                else {
                    self.setStyle(`transition: margin 0.5s ease, opacity 0.5s ease;
                                   margin-left:  ${startMargin}px;
                                   margin-right: ${startMargin}px;
                                   margin-bottom: unset; margin-top: unset;
                                   opacity: 1;`);
                    if (widget.window)
                        widget.window.set_cursor(Gdk.Cursor.new_from_name(display, 'grab'));

                    self.get_parent()._dragging = false;
                }
            }, 'drag-end'],

        ],
    }));

    return widget;
};

import { Widget } from '../../imports.js';
const { Box, Overlay, EventBox } = Widget;

import Gtk from 'gi://Gtk';

const MAX_OFFSET = 200;
const OFFSCREEN = 500;
const TRANSITION = 'transition: margin 0.5s ease, opacity 3s ease;';


export default ({ properties, connections, params } = {}) => {
  let widget = EventBox();
  let gesture = Gtk.GestureDrag.new(widget)

  widget.child = Overlay({
    ...params,
    properties: [
      ...properties,
      ['dragging', false],
    ],
    child: Box({className: 'player'}),
    connections: [
      ...connections,

      [gesture, overlay => {
        if (overlay.list().length <= 1)
          return;

        overlay._dragging = true;
        const offset = gesture.get_offset()[1];

        let playerBox = overlay.list().at(-1);

        if (offset >= 0) {
          playerBox.setStyle(`margin-left:   ${offset}px;
                              margin-right: -${offset}px;
                              ${playerBox._bgStyle}`);
        }
        else {
          let newOffset = Math.abs(offset);
          playerBox.setStyle(`margin-left: -${newOffset}px;
                              margin-right: ${newOffset}px;
                              ${playerBox._bgStyle}`);
        }
        overlay._selected = playerBox;
      }, 'drag-update'],

      [gesture, overlay => {
        if (overlay.list().length <= 1)
          return;

        overlay._dragging = false;
        const offset = gesture.get_offset()[1];

        let playerBox = overlay.list().at(-1);

        if (Math.abs(offset) > MAX_OFFSET) {
          if (offset >= 0) {
            playerBox.setStyle(`${TRANSITION}
                                margin-left:   ${OFFSCREEN}px;
                                margin-right: -${OFFSCREEN}px;
                                opacity: 0;
                                ${playerBox._bgStyle}`);
          }
          else {
            playerBox.setStyle(`${TRANSITION}
                                margin-left: -${OFFSCREEN}px;
                                margin-right: ${OFFSCREEN}px;
                                opacity: 0;
                                ${playerBox._bgStyle}`);
          }
          setTimeout(() => {
            overlay.reorder_overlay(playerBox, 0);
            playerBox.setStyle(playerBox._bgStyle);
            overlay._selected = overlay.list().at(-1);
          }, 500);
        }
        else
          playerBox.setStyle(`${TRANSITION} ${playerBox._bgStyle}`);

      }, 'drag-end'],
    ],
  });
  widget.child.list = () => widget.child.get_children().filter(ch => ch._bgStyle !== undefined);

  return widget;
};

import { Widget } from '../../imports.js';
const { Box, EventBox } = Widget;

import Gtk from 'gi://Gtk';
import Gdk from 'gi://Gdk';
const display = Gdk.Display.get_default();


export const Draggable = ({
  maxOffset = 150,
  startMargin = 0,
  endMargin = 300,
  command = () => {},
  onHover = w => {},
  onHoverLost = w => {},
  child = '',
  children = [],
  properties = [[]],
  ...params
}) => {
  let w = EventBox({
    ...params,
    properties: [
      ['dragging', false],
      ...properties,
    ],
    onHover: box => {
      box.window.set_cursor(Gdk.Cursor.new_from_name(display, 'grab'));
      onHover(box);
    },
    onHoverLost: box => {
      box.window.set_cursor(null);
      onHoverLost(box);
    },
  });

  let gesture = Gtk.GestureDrag.new(w);

  let leftAnim1 = `transition: margin 0.5s ease, opacity 0.5s ease;
                   margin-left: -${Number(maxOffset + endMargin)}px;
                   margin-right: ${Number(maxOffset + endMargin)}px;
                   opacity: 0;`;

  let leftAnim2 = `transition: margin 0.5s ease, opacity 0.5s ease;
                   margin-left: -${Number(maxOffset + endMargin)}px;
                   margin-right: ${Number(maxOffset + endMargin)}px;
                   margin-bottom: -70px; margin-top: -70px; opacity: 0;`;

  let rightAnim1 = `transition: margin 0.5s ease, opacity 0.5s ease;
                    margin-left: ${Number(maxOffset + endMargin)}px;
                    margin-right: -${Number(maxOffset + endMargin)}px;
                    opacity: 0;`;

  let rightAnim2 = `transition: margin 0.5s ease, opacity 0.5s ease;
                    margin-left: ${Number(maxOffset + endMargin)}px;
                    margin-right: -${Number(maxOffset + endMargin)}px;
                    margin-bottom: -70px; margin-top: -70px; opacity: 0;`;

  w.child = Box({
    properties: [
      ['leftAnim1', leftAnim1],
      ['leftAnim2', leftAnim2],
      ['rightAnim1', rightAnim1],
      ['rightAnim2', rightAnim2],
      ['ready', false]
    ],
    children: [
      ...children,
      child,
    ],
    style: leftAnim2,
    connections: [

      [gesture, box => {
        var offset = gesture.get_offset()[1];

        if (offset >= 0) {
          box.setStyle('margin-left: ' + Number(offset + startMargin) + 'px; ' +
                       'margin-right: -' + Number(offset + startMargin) + 'px;');
        }
        else {
          offset = Math.abs(offset);
          box.setStyle('margin-right: ' + Number(offset + startMargin) + 'px; ' +
                       'margin-left: -' + Number(offset + startMargin) + 'px;');
        }

        box.get_parent()._dragging = Math.abs(offset) > 10;

        if (w.window)
          w.window.set_cursor(Gdk.Cursor.new_from_name(display, 'grabbing'));
      }, 'drag-update'],

      [gesture, box => {
        if (!box._ready) {
          box.setStyle(`transition: margin 0.5s ease, opacity 0.5s ease;
                        margin-left: -${Number(maxOffset + endMargin)}px;
                        margin-right: ${Number(maxOffset + endMargin)}px;
                        margin-bottom: 0px; margin-top: 0px; opacity: 0;`);

          setTimeout(() => {
            box.setStyle('transition: margin 0.5s ease, opacity 0.5s ease; ' +
                         'margin-left: ' + startMargin + 'px; ' +
                         'margin-right: ' + startMargin + 'px; ' +
                         'margin-bottom: unset; margin-top: unset; opacity: 1;');
          }, 500);
          setTimeout(() => box._ready = true, 1000);
          return;
        }

        const offset = gesture.get_offset()[1];

        if (Math.abs(offset) > maxOffset) {
          if (offset > 0) {
            box.setStyle(rightAnim1);
            setTimeout(() => box.setStyle(rightAnim2), 500);
          }
          else {
            box.setStyle(leftAnim1);
            setTimeout(() => box.setStyle(leftAnim2), 500);
          }
          setTimeout(() => {
            command();
            box.destroy();
          }, 1000);
        }
        else {
          box.setStyle('transition: margin 0.5s ease, opacity 0.5s ease; ' +
                       'margin-left: ' + startMargin + 'px; ' +
                       'margin-right: ' + startMargin + 'px; ' +
                       'margin-bottom: unset; margin-top: unset; opacity: 1;');
          if (w.window)
            w.window.set_cursor(Gdk.Cursor.new_from_name(display, 'grab'));

          box.get_parent()._dragging = false;
        }
      }, 'drag-end'],

    ],
  });

  return w;
};

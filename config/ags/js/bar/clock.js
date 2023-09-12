const { Box, Label } = ags.Widget;
const { toggleWindow, openWindow } = ags.App;
const { DateTime } = imports.gi.GLib;

import { EventBox } from '../misc/cursorbox.js';

const ClockModule = ({
    interval = 1000,
    ...params
}) => Label({
    ...params,
    className: 'clock',
    connections: [
      [interval, label => {
        var time = DateTime.new_now_local();
        label.label = time.format('%a. ') + time.get_day_of_month() + time.format(' %b. %H:%M');
      }],
    ],
});

export const Clock = EventBox({
  className: 'toggle-off',
  onPrimaryClickRelease: () => toggleWindow('calendar'),
  connections: [
    [ags.App, (box, windowName, visible) => {
      if (windowName == 'calendar') {
        if (visible) {
          Clock.toggleClassName('toggle-on', true);
          openWindow('closer');
        }
        else {
          Clock.toggleClassName('toggle-on', false);
        }
      }
    }],
  ],
  child: Box({
    child: ClockModule({}),
  }),
});

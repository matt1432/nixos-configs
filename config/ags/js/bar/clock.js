const { Box, Label } = ags.Widget;
const { execAsync } = ags.Utils;
const { openWindow, closeWindow } = ags.App;
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

var calendarState = false;

export const Clock = EventBox({
  className: 'toggle-off',
  onPrimaryClickRelease: () => {
    if (calendarState) {
      Clock.toggleClassName('toggle-on', false);
      closeWindow('calendar');
      calendarState = false;
    }
    else {
      Clock.toggleClassName('toggle-on', true);
      openWindow('calendar');
      calendarState = true;
    }
  },
  child: Box({
    child: ClockModule({}),
  }),
});

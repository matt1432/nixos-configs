import { App, Widget } from '../../imports.js';
const { Box, Label } = Widget;

import GLib from 'gi://GLib';
const { DateTime } = GLib;

import EventBox from '../misc/cursorbox.js';


const ClockModule = ({
    interval = 1000,
    ...props
}) => Label({
    ...props,
    className: 'clock',
    connections: [
      [interval, self => {
        var time = DateTime.new_now_local();
        self.label = time.format('%a. ') +
                     time.get_day_of_month() +
                     time.format(' %b. %H:%M');
      }],
    ],
});

export default () => EventBox({
  className: 'toggle-off',
  onPrimaryClickRelease: () => App.toggleWindow('calendar'),
  connections: [
    [App, (self, windowName, visible) => {
      if (windowName == 'calendar') {
        self.toggleClassName('toggle-on', visible);
      }
    }],
  ],
  child: Box({
    child: ClockModule({}),
  }),
});

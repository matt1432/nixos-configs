const { Box, Label } = ags.Widget;
const { execAsync } = ags.Utils;
const { DateTime } = imports.gi.GLib;

const ClockModule = ({
    interval = 1000,
    ...props
}) => Label({
    ...props,
    className: 'clock',
    connections: [
      [interval, label => {
        var time = DateTime.new_now_local();
        label.label = time.format('%a. ') + time.get_day_of_month() + time.format(' %b. %H:%M');
      }],
    ],
});

export const Clock = Box({
  className: 'toggle-off',
  child: ClockModule({}),
});

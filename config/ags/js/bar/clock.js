const { Box, Label } = ags.Widget;
const { execAsync } = ags.Utils;
const { DateTime } = imports.gi.GLib;

const ClockModule = ({
    format = '%a. %e %b. %H:%M',
    interval = 1000,
    ...props
}) => Label({
    ...props,
    className: 'clock',
    connections: [[interval, label => label.label = DateTime.new_now_local().format(format)]],
});

export const Clock = Box({
  className: 'toggle-off',
  child: ClockModule({}),
});

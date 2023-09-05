import { EventBox } from '../common.js';

export const TabletToggle = EventBox({
  className: 'toggle-off',
  onPrimaryClickRelease: '',
  child: ags.Widget.Box({
    className: 'tablet-toggle',
    vertical: false,
    child: ags.Widget.Label({
      label: " 󰦧 ",
    }),
  }),
});

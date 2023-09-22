const { Box, Label } = ags.Widget;
const { toggleWindow } = ags.App;

import { EventBox } from '../misc/cursorbox.js';

export const QsToggle = EventBox({
  className: 'toggle-off',
  onPrimaryClickRelease: () => toggleWindow('quick-settings'),
  connections: [
    [ags.App, (box, windowName, visible) => {
      if (windowName == 'quick-settings') {
        box.toggleClassName('toggle-on', visible);
      }
    }],
  ],
  child: Box({
    className: 'quick-settings-toggle',
    vertical: false,
    child: Label({
      label: "  ",
    }),
  }),
});

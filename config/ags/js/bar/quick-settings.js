const { Box, Label } = ags.Widget;
const { toggleWindow, openWindow } = ags.App;

import { EventBox } from '../misc/cursorbox.js';

export const QsToggle = EventBox({
  className: 'toggle-off',
  onPrimaryClickRelease: () => toggleWindow('quick-settings'),
  connections: [
    [ags.App, (box, windowName, visible) => {
      if (windowName == 'quick-settings') {
        if (visible) {
          QsToggle.toggleClassName('toggle-on', true);
          openWindow('closer');
        }
        else {
          QsToggle.toggleClassName('toggle-on', false);
        }
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

import { Widget, App } from '../../imports.js';
const { Box, Label } = Widget;
const { toggleWindow } = App;

import { EventBox } from '../misc/cursorbox.js';


export const QsToggle = EventBox({
  className: 'toggle-off',
  onPrimaryClickRelease: () => toggleWindow('quick-settings'),
  connections: [
    [App, (box, windowName, visible) => {
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

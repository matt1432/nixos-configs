import { Widget, App } from '../../imports.js';
const { Box, Label } = Widget;

import EventBox from '../misc/cursorbox.js';


export default () => EventBox({
  className: 'toggle-off',
  onPrimaryClickRelease: () => App.toggleWindow('quick-settings'),
  connections: [[App, (self, windowName, visible) => {
    if (windowName == 'quick-settings')
      self.toggleClassName('toggle-on', visible);
  }]],
  child: Box({
    className: 'quick-settings-toggle',
    vertical: false,
    child: Label({
      label: "  ",
    }),
  }),
});

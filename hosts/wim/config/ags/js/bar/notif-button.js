import { App, Notifications, Widget } from '../../imports.js';
const { Box, Label, Icon } = Widget;

import Separator from '../misc/separator.js';
import EventBox  from '../misc/cursorbox.js';


export default () => EventBox({
  className: 'toggle-off',
  onPrimaryClickRelease: () => App.toggleWindow('notification-center'),
  connections: [[App, (self, windowName, visible) => {
    if (windowName == 'notification-center')
      self.toggleClassName('toggle-on', visible);
  }]],
  child: Box({
    className: 'notif-panel',
    vertical: false,
    children: [
      Separator(28),

      Icon({
        connections: [[Notifications, self => {
          if (Notifications.dnd) {
            self.icon = 'notification-disabled-symbolic'
          }
          else {
            if (Notifications.notifications.length > 0) {
              self.icon = 'notification-new-symbolic'
            }
            else {
              self.icon = 'notification-symbolic'
            }
          }
        }]],
      }),

      Separator(8),

      Label({
        binds: [
          ['label', Notifications, 'notifications', n => String(n.length)],
        ],
      }),

    ],
  }),
});

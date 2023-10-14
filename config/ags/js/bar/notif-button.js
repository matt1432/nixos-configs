import { App, Notifications, Widget } from '../../imports.js';
const { Box, Label, Icon } = Widget;

import { Separator } from '../misc/separator.js';
import { EventBox } from '../misc/cursorbox.js';


export const NotifButton = EventBox({
  className: 'toggle-off',
  onPrimaryClickRelease: () => App.toggleWindow('notification-center'),
  connections: [
    [App, (box, windowName, visible) => {
      if (windowName == 'notification-center') {
        box.toggleClassName('toggle-on', visible);
      }
    }],
  ],
  child: Box({
    className: 'notif-panel',
    vertical: false,
    children: [
      Separator(28),

      Icon({
        connections: [
          [Notifications, icon => {
            if (Notifications.dnd) {
              icon.icon = 'notification-disabled-symbolic'
            }
            else {
              if (Notifications.notifications.length > 0) {
                icon.icon = 'notification-new-symbolic'
              }
              else {
                icon.icon = 'notification-symbolic'
              }
            }
          }],
        ],
      }),

      Separator(8),

      Label({
        connections: [
          [Notifications, label => {
            label.label = String(Notifications.notifications.length);
          }],
        ],
      }),

    ],
  }),
});

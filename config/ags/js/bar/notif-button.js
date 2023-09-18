const { Box, Label, Icon } = ags.Widget;
const { toggleWindow, openWindow } = ags.App;
const { Notifications } = ags.Service;

import { Separator } from '../misc/separator.js';
import { EventBox } from '../misc/cursorbox.js';

export const NotifButton = EventBox({
  className: 'toggle-off',
  onPrimaryClickRelease: () => toggleWindow('notification-center'),
  connections: [
    [ags.App, (box, windowName, visible) => {
      if (windowName == 'notification-center') {
        if (visible) {
          NotifButton.toggleClassName('toggle-on', true);
          openWindow('closer');
        }
        else {
          NotifButton.toggleClassName('toggle-on', false);
        }
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

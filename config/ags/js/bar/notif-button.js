const { Box, Label, Icon } = ags.Widget;
const { toggleWindow } = ags.App;
const { Notifications } = ags.Service;

import { Separator } from '../misc/separator.js';
import { EventBox } from '../misc/cursorbox.js';

export const NotifButton = EventBox({
  className: 'toggle-off',
  onPrimaryClickRelease: () => toggleWindow('notification-center'),
  connections: [
    [ags.App, (box, windowName, visible) => {
      if (windowName == 'notification-center') {
        NotifButton.toggleClassName('toggle-on', visible);
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
            // TODO: add no notifs vs notifs
            icon.icon = Notifications.dnd
                        ? 'notifications-disabled-symbolic'
                        : 'preferences-system-notifications-symbolic';
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

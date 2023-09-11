const { Box, Label, Icon } = ags.Widget;
const { openWindow, closeWindow } = ags.App;
const { Notifications } = ags.Service;

import { Separator } from '../misc/separator.js';
import { EventBox } from '../misc/cursorbox.js';

var notifButtonState = false;

export const NotifButton = EventBox({
  className: 'toggle-off',
  onPrimaryClickRelease: () => {
    if (notifButtonState) {
      NotifButton.toggleClassName('toggle-on', false);
      closeWindow('notification-center');
      notifButtonState = false;
    }
    else {
      NotifButton.toggleClassName('toggle-on', true);
      openWindow('notification-center');
      notifButtonState = true;
    }
  },
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

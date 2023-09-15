const { Notifications } = ags.Service;
const { Button, Label, Box, Icon, Scrollable, Window, Revealer } = ags.Widget;
const { timeout } = ags.Utils;
const { getWindow } = ags.App;

import Notification from './base.js';
import { EventBox } from '../misc/cursorbox.js'

const ClearButton = () => EventBox({
  child: Button({
    onPrimaryClickRelease: button => {
      button._popups.children.forEach(ch => ch.child.setStyle(ch.child._leftAnim));
      button._notifList.children.forEach(ch => {
        ch.child.setStyle(ch.child._rightAnim);
        timeout(500, () => {
          button._notifList.remove(ch);
          Notifications.close(ch._id);
        });
      });
    },
    properties: [['notifList'], ['popups']],
    connections: [[Notifications, button => {
      if (!button._notifList)
        button._notifList = getWindow('notification-center').child.children[1].children[0].child.child.children[0];

      if (!button._popups)
        button._popups = getWindow('notifications').child.children[0].child;

      button.sensitive = Notifications.notifications.length > 0;
    }]],
    child: Box({
      children: [
        Label('Clear '),
        Icon({
          connections: [[Notifications, icon => {
            icon.icon = Notifications.notifications.length > 0
                      ? 'user-trash-full-symbolic' : 'user-trash-symbolic';
          }]],
        }),
      ],
    }),
  }),
});

const Header = () => Box({
  className: 'header',
  children: [
    Label({ label: 'Notifications', hexpand: true, xalign: 0 }),
    ClearButton(),
  ],
});

const NotificationList = () => Box({
  vertical: true,
  vexpand: true,
  connections: [
    [Notifications, (box, id) => {
      if (box.children.length == 0) {
        box.children = Notifications.notifications
          .reverse()
          .map(n => Notification({ ...n, command: i => Notifications.close(i), }));
      }
      else if (id) {
        box.add(Notification({
          ...Notifications.getNotification(id),
          command: i => Notifications.close(i),
        }));
        box.show_all();
      }

    }, 'notified'],

    [Notifications, (box, id) => {
      for (const ch of box.children) {
        if (ch._id == id) {
          ch.child.setStyle(ch.child._rightAnim);
          timeout(500, () => box.remove(ch));
          return;
        }
      }
    }, 'closed'],

    [Notifications, box => box.visible = Notifications.notifications.length > 0],
  ],
});

const Placeholder = () => Revealer({
  transition: 'crossfade',
  connections: [[Notifications, box => {
    box.revealChild = Notifications.notifications.length === 0;
  }]],
  child: Box({
    className: 'placeholder',
    vertical: true,
    valign: 'center',
    halign: 'center',
    vexpand: true,
    hexpand: true,
    children: [
      Icon('notification-disabled-symbolic'),
      Label('Your inbox is empty'),
    ],
  }),
});

export const NotificationCenter = Window({
  name: 'notification-center',
  popup: true,
  layer: 'overlay',
  anchor: 'top right',
  margin: [ 8, 60, 0, 0 ],
  child: Box({
    className: 'notification-center',
    vertical: true,
    children: [
      Header(),
      Box({
        className: 'notification-wallpaper-box',
        children: [Scrollable({
          className: 'notification-list-box',
          hscroll: 'never',
          vscroll: 'automatic',
          child: Box({
            className: 'notification-list',
            vertical: true,
            children: [
              NotificationList(),
              Placeholder(),
            ],
          }),
        })],
      }),
    ],
  }),
});

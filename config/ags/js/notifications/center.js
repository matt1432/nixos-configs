const { Notifications } = ags.Service;
const { Button, Label, Box, Icon, Scrollable, Window, Revealer } = ags.Widget;
const { timeout } = ags.Utils;

import Notification from './base.js';
import { EventBox } from '../misc/cursorbox.js'

const ClearButton = () => EventBox({child: Button({
  onClicked: Notifications.clear,
  connections: [[Notifications, button => {
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
})});

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

      box.visible = Notifications.notifications.length > 0;
    }, 'notified'],

    [Notifications, (box, id) => {
      box.visible = Notifications.notifications.length > 0;
      for (const ch of box.children) {
        if (ch._id == id) {
          ch.child.setStyle(ch.child._rightAnim);
          timeout(500, () => box.remove(ch));
          return;
        }
      }
    }, 'closed'],
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

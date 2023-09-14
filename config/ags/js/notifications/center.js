const { Notifications } = ags.Service;
const { Button, Label, Box, Icon, Scrollable, Window, Revealer } = ags.Widget;

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
  connections: [[Notifications, box => {
    box.children = Notifications.notifications
      .reverse()
      .map(n => Notification(n));

    box.visible = Notifications.notifications.length > 0;
  }]],
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

const { GLib } = imports.gi;
const { Notifications } = ags.Service;
const { lookUpIcon, timeout } = ags.Utils;
const { Box, Icon, Label, Button } = ags.Widget;

import { Draggable } from '../misc/drag.js';
import { EventBox } from '../misc/cursorbox.js'

// TODO: launch app when click on icon
const NotificationIcon = ({ appEntry, appIcon, image }) => {
  if (image) {
    return Box({
      valign: 'start',
      hexpand: false,
      className: 'icon img',
      style: `
        background-image: url("${image}");
        background-size: contain;
        background-repeat: no-repeat;
        background-position: center;
        min-width: 78px;
        min-height: 78px;
      `,
    });
  }

  let icon = 'dialog-information-symbolic';
  if (lookUpIcon(appIcon)) {
    icon = appIcon;
  }

  if (lookUpIcon(appEntry)) {
    icon = appEntry;
  }

  return Box({
    valign: 'start',
    hexpand: false,
    className: 'icon',
    style: `
      min-width: 78px;
      min-height: 78px;
    `,
    children: [Icon({
      icon, size: 58,
      halign: 'center',
      hexpand: true,
      valign: 'center',
      vexpand: true,
    })],
  });
};

export default ({ id, summary, body, actions, urgency, time, ...icon }) => Draggable({
  maxOffset: 200,
  command: () => Notifications.close(id),
  properties: [['hovered', false]],
  onHover: w => {
    if (!w._hovered) {
      w._hovered = true;
    }
  },
  onHoverLost: w => {
    if (w._hovered) {
      w._hovered = false;
    }
  },

  child: Box({
    className: `notification ${urgency}`,
    vexpand: false,
    // Notification
    child: Box({
      vertical: true,
      children: [
        // Content
        Box({
          children: [
            NotificationIcon(icon),
            Box({
              hexpand: true,
              vertical: true,
              children: [
                // Top of Content
                Box({
                  children: [
                    Label({
                      className: 'title',
                      xalign: 0,
                      justification: 'left',
                      hexpand: true,
                      maxWidthChars: 24,
                      truncate: 'end',
                      wrap: true,
                      label: summary,
                      useMarkup: summary.startsWith('<'),
                    }),
                    Label({
                      className: 'time',
                      valign: 'start',
                      label: GLib.DateTime.new_from_unix_local(time).format('%H:%M'),
                    }),
                    EventBox({
                      reset: false,
                      child: Button({
                        className: 'close-button',
                        valign: 'start',
                        onClicked: () => Notifications.close(id),
                        child: Icon('window-close-symbolic'),
                      }),
                    }),
                  ],
                }),
                Label({
                  className: 'description',
                  hexpand: true,
                  useMarkup: true,
                  xalign: 0,
                  justification: 'left',
                  label: body,
                  wrap: true,
                }),
              ],
            }),
          ],
        }),
        // Actions
        Box({
          className: 'actions',
          children: actions.map(action => Button({
            className: 'action-button',
            onClicked: () => Notifications.invoke(id, action.id),
            hexpand: true,
            child: Label(action.label),
          })),
        }),
      ],
    }),
  }),
});

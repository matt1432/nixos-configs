import { Applications, Utils, Widget } from '../../imports.js';
const { lookUpIcon, execAsync } = Utils;
const { Box, Icon, Label, Button } = Widget;

import GLib from 'gi://GLib';

import Gesture from '../misc/drag.js';
import { EventBox } from '../misc/cursorbox.js'


const NotificationIcon = notif => {
  let iconCmd = () => {};

  if (Applications.query(notif.appEntry).length > 0) {
    let app = Applications.query(notif.appEntry)[0];

    if (app.app.get_string('StartupWMClass') != null) {
      iconCmd = box => {
        if (!box.get_parent().get_parent().get_parent().get_parent().get_parent()._dragging) {
          execAsync(['bash', '-c', `$AGS_PATH/launch-app.sh ${app.app.get_string('StartupWMClass')} ${app.app.get_string('Exec')}`]).catch(print);
          globalThis.closeAll();
        }
      }
    }
    else if (app.app.get_filename().includes('discord')) {
      iconCmd = box => {
        if (!box.get_parent().get_parent().get_parent().get_parent().get_parent()._dragging) {
          execAsync(['bash', '-c', `$AGS_PATH/launch-app.sh discord ${app.app.get_string('Exec')}`])
            .catch(print);
          globalThis.closeAll();
        }
      }
    }
  }

  if (notif.image) {
    return EventBox({
      onPrimaryClickRelease: iconCmd,
      child: Box({
        valign: 'start',
        hexpand: false,
        className: 'icon img',
        style: `
          background-image: url("${notif.image}");
          background-size: contain;
          background-repeat: no-repeat;
          background-position: center;
          min-width: 78px;
          min-height: 78px;
        `,
      }),
    });
  }

  let icon = 'dialog-information-symbolic';
  if (lookUpIcon(notif.appIcon)) {
    icon = notif.appIcon;
  }

  if (lookUpIcon(notif.appEntry)) {
    icon = notif.appEntry;
  }

  return EventBox({
    onPrimaryClickRelease: iconCmd,
    child: Box({
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
    }),
  });
};

export default ({ notif, command = () => {}} = {}) => {
  const BlockedApps = [
    'Spotify',
  ];

  if (BlockedApps.find(app => app == notif.appName)) {
    notif.close();
    return;
  }

  return Gesture({
    maxOffset: 200,
    command: () => command(),
    properties: [
      ['hovered', false],
      ['id', notif.id],
    ],
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
      className: `notification ${notif.urgency}`,
      vexpand: false,
      // Notification
      child: Box({
        vertical: true,
        children: [
          // Content
          Box({
            children: [
              NotificationIcon(notif),
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
                        label: notif.summary,
                        useMarkup: notif.summary.startsWith('<'),
                      }),
                      Label({
                        className: 'time',
                        valign: 'start',
                        label: GLib.DateTime.new_from_unix_local(notif.time).format('%H:%M'),
                      }),
                      EventBox({
                        reset: false,
                        child: Button({
                          className: 'close-button',
                          valign: 'start',
                          onClicked: () => notif.close(),
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
                    label: notif.body,
                    wrap: true,
                  }),
                ],
              }),
            ],
          }),
          // Actions
          Box({
            className: 'actions',
            children: notif.actions.map(action => Button({
              className: 'action-button',
              onClicked: () => notif.invoke(action.id),
              hexpand: true,
              child: Label(action.label),
            })),
          }),
        ],
      }),
    }),
  });
};

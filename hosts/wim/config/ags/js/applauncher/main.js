import { App, Applications, Utils, Widget } from '../../imports.js';
const { Label, Box, Icon, Button, Scrollable, Entry, EventBox } = Widget;

import { Separator } from '../misc/separator.js';
import { PopupWindow } from '../misc/popup.js';

const icons = {
  apps: {
    apps: 'view-app-grid-symbolic',
    search: 'preferences-system-search-symbolic',
  }
};


const AppItem = (app, window) => {
  if (app.app.get_string('Icon') == 'Nextcloud')
    return;

  return Button({
    className: 'app',
    connections: [['clicked', () => {
      App.closeWindow(window);
      Utils.exec(`hyprctl dispatch exec ${app.executable}`);
      ++app.frequency;
    }]],
    child: Box({
      children: [
        Icon({
          icon: app.app.get_string('Icon'),
          size: 42,
        }),
        Box({
          vertical: true,
          children: [
            Label({
              className: 'title',
              label: app.name,
              xalign: 0,
              valign: 'center',
              ellipsize: 3,
            }),
            Label({
              className: 'description',
              label: app.description || '',
              wrap: true,
              xalign: 0,
              justification: 'left',
              valign: 'center',
            }),
          ],
        }),
      ],
    }),
  });
};

const Applauncher = ({ windowName = 'applauncher' } = {}) => {
  const list = Box({ vertical: true });
  const placeholder = Label({
    label: " Couldn't find a match",
    className: 'placeholder',
  });
  const entry = Entry({
    hexpand: true,
    placeholderText: 'Search',
    onAccept: ({ text }) => {
      const list = Applications.query(text);
      if (list[0]) {
        App.toggleWindow(windowName);
        list[0].launch();
      }
    },
    onChange: ({ text }) => {
      list.children = Applications.query(text).map(app => [
          Separator(4),
          AppItem(app, windowName),
      ]).flat();
      list.add(Separator(4));
      list.show_all();

      placeholder.visible = list.children.length === 1;
    },
  });

  return Box({
    className: 'applauncher',
    properties: [['list', list]],
    vertical: true,
    children: [
      Box({
        className: 'header',
        children: [
          Icon(icons.apps.search),
          entry,
        ],
      }),
      Scrollable({
        hscroll: 'never',
        child: Box({
          vertical: true,
          children: [list, placeholder],
        }),
      }),
    ],
    connections: [[App, (_b, name, visible) => {
      if (name !== windowName)
        return;

      entry.set_text('-'); // force onChange
      entry.set_text('');
      if (visible)
        entry.grab_focus();
    }]],
  });
};

// FIXME: make it so I don't have to click to trigger onHoverLost
export default PopupWindow({
  name: 'applauncher',
  child: EventBox({
    onHover: () => {
      App.getWindow('applauncher').focusable = true;
    },
    onHoverLost: () => {
      App.getWindow('applauncher').focusable = false;
    },
    child: Applauncher(),
  }),
});

const { Window, CenterBox, Box, Label, Revealer, Icon } = ags.Widget;
const { closeWindow } = ags.App;
const { ToggleButton } = imports.gi.Gtk;

import { ButtonGrid } from './button-grid.js';
import { SliderBox } from './slider-box.js';
import Player from '../media-player/player.js';
import { EventBox } from '../misc/cursorbox.js';
import { PopUp } from '../misc/popup.js';

const QuickSettingsWidget = Box({
  className: 'qs-container',
  vertical: true,
  children: [

    Box({
      className: 'quick-settings',
      vertical: true,
      children: [

        Label({
          label: 'Control Center',
          className: 'title',
          halign: 'start',
          style: 'margin-left: 20px'
        }),

        ButtonGrid,

        SliderBox,

        EventBox({
          child: ags.Widget({
            type: ToggleButton,
            connections: [['toggled', button => {
              if (button.get_active()) {
                button.child.setStyle("-gtk-icon-transform: rotate(0deg);");
                button.get_parent().get_parent().get_parent().children[1].revealChild = true;
              }
              else {
                button.child.setStyle('-gtk-icon-transform: rotate(180deg);');
                button.get_parent().get_parent().get_parent().children[1].revealChild = false;
              }
            }]],
            child: Icon({
              icon: 'folder-download-symbolic',
              className: 'arrow',
              style: `-gtk-icon-transform: rotate(180deg);`,
            }),
          }),
        }),

      ],
    }),

    Revealer({
      transition: 'slide_down',
      child: Player(),
    })

  ],
});

export const QuickSettings = Window({
  name: 'quick-settings',
  layer: 'overlay',
  anchor: 'top right',
  margin: [ 8, 5, 0, ],
  child: PopUp({
    name: 'quick-settings',
    child: QuickSettingsWidget,
  }),
});

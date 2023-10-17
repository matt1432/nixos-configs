import { Mpris, Widget } from '../../imports.js';
const { Box, Label, Revealer, Icon } = Widget;

import Gtk from 'gi://Gtk';

import ButtonGrid  from './button-grid.js';
import SliderBox   from './slider-box.js';
import Player      from '../media-player/player.js';
import EventBox    from '../misc/cursorbox.js';
import PopupWindow from '../misc/popup.js';


const QuickSettingsWidget = () => Box({
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

        ButtonGrid(),

        SliderBox(),

        EventBox({
          child: Widget({
            type: Gtk.ToggleButton,
            setup: btn => {
              const id = Mpris.connect('changed', () => {
                btn.set_active(Mpris.players.length > 0);
                Mpris.disconnect(id);
              });
            },
            connections: [['toggled', button => {
              let rev = button.get_parent().get_parent().get_parent().children[1];

              if (button.get_active()) {
                button.child.setStyle("-gtk-icon-transform: rotate(0deg);");
                rev.revealChild = true;
              }
              else {
                button.child.setStyle('-gtk-icon-transform: rotate(180deg);');
                rev.revealChild = false;
              }
            }]],
            child: Icon({
              icon: 'go-down-symbolic',
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

export default () => PopupWindow({
  name: 'quick-settings',
  anchor: [ 'top', 'right' ],
  margin: [ 8, 5, 0, ],
  child: QuickSettingsWidget(),
});

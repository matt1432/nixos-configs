import { Widget, Hyprland, Utils, Variable } from '../../imports.js';
const { Box, EventBox } = Widget;

const Revealed = Variable(true);
const Hovering = Variable(false);

import { Gesture } from './gesture.js';


export const Revealer = params => Box({
  style: 'min-height: 1px',
  vertical: true,
  children: [
    Widget.Revealer({
      transition: 'slide_down',
      setup: self => self.revealChild = true,
      properties: [
        ['timeouts', []],
      ],
      connections: [[Hyprland, self => {
        Utils.execAsync('hyprctl activewindow -j')
          .then(result => {
            let client = JSON.parse(result);
            if (client.fullscreen !== Revealed.value) {
              Revealed.value = client.fullscreen;

              if (Revealed.value) {
                setTimeout(() => {
                  if (Revealed.value)
                    self.revealChild = false
                }, 2000);
              }
              else {
                self.revealChild = true;
              }
            }
          }).catch(print);
      }]],

      child: Gesture({
        onHover: () => Hovering.value = true,
        onHoverLost: self => {
          Hovering.value = false;
          if (Revealed.value) {
            setTimeout(() => {
              if (!Hovering.value) {
                self.get_parent().get_parent().children[1].revealChild = true;
                self.get_parent().revealChild = false;
              }
            }, 2000);
          }
        },
        ...params,
      }),
    }),

    Widget.Revealer({
      connections: [[Revealed, self => {
        if (Revealed.value) {
          setTimeout(() => {
            if (Revealed.value)
              self.revealChild = true;
          }, 2000);
        }
        else {
          self.revealChild = false;
        }
      }]],
      child: EventBox({
        onHover: self => {
          Hovering.value = true;
          self.get_parent().get_parent().children[0].revealChild = true;
          self.get_parent().revealChild = false;
        },
        child: Box({
          style: 'min-height: 50px;',
        }),
      }),
    }),
  ],
});

const { Box, CenterBox, Label, Icon } = ags.Widget;
const { Network, Bluetooth, Audio } = ags.Service;
const { exec } = ags.Utils;

import { EventBox } from '../misc/cursorbox.js';

const GridButton = ({ command = () => {}, secondaryCommand = () => {}, icon } = {}) => Box({
  className: 'grid-button',
  children: [

    EventBox({
      className: 'left-part',
      onPrimaryClickRelease: () => command(),
      child: icon,
    }),

    EventBox({
      className: 'right-part',
      onPrimaryClickRelease: () => secondaryCommand(),
      child: Label({
        label: " ",
        className: 'grid-chev',
      }),
    }),

  ],
});

const FirstRow = Box({
  className: 'button-row',
  halign: 'center',
  style: 'margin-top: 15px; margin-bottom: 7px;',
  children: [

    GridButton({
      command: () => Network.toggleWifi(),
      secondaryCommand: () => exec("bash -c 'nm-connection-editor &'"),
      icon: Icon({
        className: 'grid-label',
        connections: [[Network, icon => {
          if (Network.wifi.enabled) {
            icon.icon = 'network-wireless-connected-symbolic';
          }
          else {
            icon.icon = 'network-wireless-offline-symbolic';
          }
        }, 'changed']],
      }),
    }),

    GridButton({
      command: () => exec("bash -c '$AGS_PATH/qs-toggles.sh blue-toggle'"),
      secondaryCommand: () => exec("bash -c 'blueberry &'"),
      icon: Icon({
        className: 'grid-label',
        connections: [[Bluetooth, icon => {
          if (Bluetooth.enabled) {
            icon.icon = 'bluetooth-active-symbolic';
            exec('bash -c "echo 󰂯 > $HOME/.config/.bluetooth"');
          }
          else {
            icon.icon = 'bluetooth-disabled-symbolic';
            exec('bash -c "echo 󰂲 > $HOME/.config/.bluetooth"');
          }
        }, 'changed']],
      })
    }),

    GridButton({
      command: () => exec('bash -c "$AGS_PATH/qs-toggles.sh toggle-radio"'),
      secondaryCommand: () => exec("notify-send 'set this up moron'"),
      icon: Icon({
        className: 'grid-label',
        connections: [[Network, icon => {
          if (Network.wifi.enabled) {
            icon.icon = 'airplane-mode-disabled-symbolic';
          }
          else {
            icon.icon = 'airplane-mode-symbolic';
          }
        }, 'changed']],
      }),
    }),

  ],
});

const SubRow = CenterBox({
  halign: 'start',
  children: [

    Label({
      className: 'sub-label',
      truncate: 'end',
      maxWidthChars: 12,
      connections: [[Network, label => {
        label.label = Network.wifi.ssid;
      }, 'changed']],
    }),

    Label({
      className: 'sub-label',
      truncate: 'end',
      maxWidthChars: 12,
      connections: [[Bluetooth, label => {
        label.label = String(Bluetooth.connectedDevices[0]);
      }, 'changed']],
    }),

    Label({
      className: '',
      truncate: 'end',
      maxWidthChars: 12,
      /*connections: [[Network, label => {
        label.label = Network.wifi.ssid;
      }, 'changed']],*/
    }),

  ],
});

const items = {
  101: 'audio-volume-overamplified-symbolic',
  67: 'audio-volume-high-symbolic',
  34: 'audio-volume-medium-symbolic',
  1: 'audio-volume-low-symbolic',
  0: 'audio-volume-muted-symbolic',
};

const itemsMic = {
  2: 'audio-input-microphone-high-symbolic',
  1: 'audio-input-microphone-muted-symbolic',
  0: 'audio-input-microphone-muted-symbolic',
};

const SecondRow = Box({
  className: 'button-row',
  halign: 'center',
  style: 'margin-top: 7px; margin-bottom: 15px;',
  children: [

    GridButton({
      command: () => exec("swayosd-client --output-volume mute-toggle"),
      secondaryCommand: () => exec('bash -c "pavucontrol &"'),
      icon: Icon({
        className: 'grid-label',
        connections: [[Audio, icon => {
          if (Audio.speaker) {
            if (Audio.speaker.isMuted) {
              icon.icon = items[0];
            }
            else {
              const vol = Audio.speaker.volume * 100;
              for (const threshold of [-1, 0, 33, 66, 100]) {
                if (vol > threshold + 1) {
                  icon.icon = items[threshold + 1];
                }
              }
            }
          }
        }, 'speaker-changed']],
      }),
    }),

    GridButton({
      command: () => exec("swayosd-client --input-volume mute-toggle"),
      secondaryCommand: () => exec('bash -c "pavucontrol &"'),
      icon: Icon({
        className: 'grid-label',
        connections: [[Audio, icon => {
          if (Audio.microphone) {
            if (Audio.microphone.isMuted) {
              icon.icon = itemsMic[0];
            }
            else {
              const vol = Audio.microphone.volume * 100;
              for (const threshold of [-1, 0, 1]) {
                if (vol > threshold + 1) {
                  icon.icon = itemsMic[threshold + 1];
                }
              }
            }
          }
        }, 'microphone-changed']],
      })
    }),

    GridButton({
      command: () => exec('bash -c "$LOCK_PATH/lock.sh &"'),
      secondaryCommand: () => {
        ags.App.openWindow('closer');
        ags.App.openWindow('powermenu');
      },
      icon: Label({
        className: 'grid-label',
        label: " 󰌾 ", 
      }),
    }),

  ],
});


export const ButtonGrid = Box({
  className: 'button-grid',
  vertical: true,
  halign: 'center',
  children: [
    FirstRow,
    SubRow,
    SecondRow,
  ],
});

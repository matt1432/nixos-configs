const { Window, CenterBox, Label } = ags.Widget;

import { PopUp } from './misc/popup.js';
import { Button } from './misc/cursorbox.js'

const PowermenuWidget = CenterBox({
  className: 'powermenu',
  vertical: false,

  startWidget: Button({
    className: 'shutdown',
    onPrimaryClickRelease: 'systemctl poweroff',

    child: Label({
      label: '襤',
    }),
  }),

  centerWidget: Button({
    className: 'reboot',
    onPrimaryClickRelease: 'systemctl reboot',

    child: Label({
      label: '勒',
    }),
  }),

  endWidget: Button({
    className: 'logout',
    onPrimaryClickRelease: 'hyprctl dispatch exit',

    child: Label({
      label: '',
    }),
  }),
});

export const Powermenu = Window({
  name: 'powermenu',
  popup: true,
  layer: 'overlay',
  child: PopUp({
    name: 'powermenu',
    transition: 'crossfade',
    child: PowermenuWidget,
  }),
});

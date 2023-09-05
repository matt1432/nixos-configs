const { Window, CenterBox, Box } = ags.Widget;

import { Separator, EventBox }  from '../common.js';
import { CurrentWindow }        from './current-window.js';
import { Workspaces }           from './workspaces.js';
import { OskToggle }            from './osk-toggle.js'
import { Heart }                from './heart.js'

export const Bar = Window({
  name: 'left-bar',
  layer: 'overlay',
  anchor: 'top left right',
  exclusive: true,

  child: CenterBox({
    className: 'transparent',
    halign: 'fill',
    style: 'margin-top: 5px; margin-left: 5px;',
    vertical: false,
    
    children: [

      // Left
      Box({
        halign: 'start',
        children: [

          OskToggle,
  
          Separator(12),

          EventBox({
            className: 'toggle-off',
            onPrimaryClickRelease: '',
            child: ags.Widget.Box({
              className: 'tablet-toggle',
              vertical: false,

              child: ags.Widget.Label({
                label: " 󰦧 ",
              }),
            }),
          }),
      
          Separator(12),

          Heart,

          Separator(12),

          Workspaces(),

        ],
      }),

      // Center
      CurrentWindow,

      // Right
      Box({
        halign: 'end',
      }),
    ],
  }),
});

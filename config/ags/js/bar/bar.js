const { Window, CenterBox, Box } = ags.Widget;

import { Separator }      from '../common.js';
import { CurrentWindow }  from './current-window.js';
import { Workspaces }     from './workspaces.js';
import { OskToggle }      from './osk-toggle.js';
import { Heart }          from './heart.js';
import { TabletToggle }   from './tablet-toggle.js';
import { QsToggle }       from './quick-settings.js';
import { NotifButton }    from './notif-button.js';
import { Clock }          from './clock.js';
import { SysTray }        from './systray.js';
import { Batt }           from './battery.js';
import { Brightness }     from './brightness.js';

export const Bar = Window({
  name: 'bar',
  layer: 'overlay',
  anchor: 'top left right',
  exclusive: true,

  child: CenterBox({
    className: 'transparent',
    halign: 'fill',
    style: 'margin: 5px',
    vertical: false,
    
    startWidget: Box({
      halign: 'start',
      children: [

        OskToggle,
  
        Separator(12),

        TabletToggle,
      
        Separator(12),

        Heart,

        Separator(12),

        SysTray,

        Separator(12),

        Brightness,

        Separator(12),

        Workspaces,

      ],
    }),

    centerWidget: CurrentWindow,

    endWidget: Box({
      halign: 'end',
      children: [
        Batt,
        
        Separator(12),
      
        Clock,

        Separator(12),

        NotifButton,

        Separator(12),

        QsToggle,
      ],
    }),
  }),
});

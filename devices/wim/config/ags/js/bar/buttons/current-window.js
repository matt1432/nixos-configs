import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

import { Label } from 'resource:///com/github/Aylur/ags/widget.js';


export default () => Label({
    css: 'color: #CBA6F7; font-size: 18px',
    truncate: 'end',
    binds: [['label', Hyprland.active.client, 'title']],
});

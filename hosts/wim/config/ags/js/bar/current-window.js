import { Widget, Hyprland } from '../../imports.js';
const { Label } = Widget;


export default () => Label({
    style: 'color: #CBA6F7; font-size: 18px',
    truncate: 'end',
    binds: [['label', Hyprland.active.client, 'title']],
});

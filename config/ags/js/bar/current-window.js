import { Widget, Hyprland } from '../../imports.js';
const { Label } = Widget;


export const CurrentWindow = Label({
  style: 'color: #CBA6F7; font-size: 18px',
  truncate: 'end',
  connections: [
    [Hyprland, label => {
      label.label = Hyprland.active.client.title;
    }, 'changed'],
  ],
});

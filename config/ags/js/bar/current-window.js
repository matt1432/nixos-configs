const { Hyprland } = ags.Service;
const { Label } = ags.Widget;
const { Gtk } = imports.gi;

export const CurrentWindow = Label({
  style: 'color: #CBA6F7; font-size: 18px',
  truncate: 'end',
  connections: [
    [Hyprland, label => {
      label.label = Hyprland.active.client.title;
    }, 'changed'],
  ],
});

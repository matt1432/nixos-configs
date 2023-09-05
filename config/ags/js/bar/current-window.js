// https://github.com/Aylur/ags/wiki/Widgets

const { Hyprland } = ags.Service;
const { Label } = ags.Widget;
const { Gtk } = imports.gi;

const currentWindow = () => Label({
  style: 'color: #CBA6F7; font-size: 18px',
  connections: [
    [Hyprland, label => {
      label.label = Hyprland.active.client.title;
    }, 'changed'],
  ],
});

export const CurrentWindow = currentWindow();

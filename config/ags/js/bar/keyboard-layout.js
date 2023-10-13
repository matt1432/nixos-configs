import { Hyprland, Utils, Widget } from '../../imports.js';
const { Label, Box, Icon } = Widget;

const DEFAULT_KB = "at-translated-set-2-keyboard";

export default Box({
  className: 'toggle-off',
  children: [
    Icon({
      icon: 'input-keyboard-symbolic',
      style: 'margin-right: 4px;',
    }),
    Label({
      connections: [[Hyprland, (self, _n, layout) => {
        if (!layout) {
          let obj = Utils.exec('hyprctl devices -j')
          let keyboards = JSON.parse(obj)['keyboards'];
          let kb = keyboards.find(val => val.name === DEFAULT_KB);

          layout = kb['active_keymap'];

          self.label = layout;
        }
        else {
          self.label = layout;
        }
      }, 'keyboard-layout']],
    }),
  ],
});

import { execAsync, writeFile } from 'resource:///com/github/Aylur/ags/utils.js';
import { Powermenu } from 'file:///home/matt/.nix/config/ags/powermenu/powermenu.js';
import { Closer } from 'file:///home/matt/.nix/config/ags/closer/closer.js';

const scss = ags.App.configDir + '/style.scss';
const css = ags.App.configDir + '/style.css';

ags.Utils.exec(`touch ${css}`);
ags.Utils.exec(`sassc ${scss} ${css}`);

export default {
    style: css,
    windows: [
      Powermenu,
      Closer,
    ]
}

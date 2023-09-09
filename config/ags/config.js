import { exec } from 'resource:///com/github/Aylur/ags/utils.js';
import { Powermenu } from './js/powermenu.js';
import { Bar } from './js/bar/bar.js';
import { DragTest } from './js/test/drag.js';
import { Closer } from './js/common.js';

const scss = ags.App.configDir + '/scss/main.scss';
const css = ags.App.configDir + '/style.css';

exec(`touch ${css}`);
exec(`sassc ${scss} ${css}`);

exec(`bash -c "$AGS_PATH/startup.sh"`);

export default {
    style: css,
    windows: [
      Powermenu,
      Bar,
      Closer,
      DragTest,
    ]
}

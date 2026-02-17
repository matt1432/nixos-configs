import app from 'ags/gtk3/app';
import { subprocess } from 'ags/process';

import style from '../style/greeter.scss';
import Greeter from '../widgets/greeter';

// FIXME: white flash
export default () => {
    app.start({
        css: style,
        instanceName: 'greeter',

        main: () => {
            Greeter(subprocess('hyprpaper', () => {}, console.error));
        },
    });
};

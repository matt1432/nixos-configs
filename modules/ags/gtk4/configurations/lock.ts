import app from 'ags/gtk4/app';

import style from '../style.scss';
import Lockscreen from '../widgets/lockscreen';

export default () => {
    app.start({
        css: style,
        instanceName: 'lock',

        requestHandler() {
            globalThis.authFinger();
        },

        main: () => {
            Lockscreen();
        },
    });
};

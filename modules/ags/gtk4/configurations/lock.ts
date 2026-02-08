import { App } from 'astal/gtk4';

import style from '../style.scss';
import Lockscreen from '../widgets/lockscreen';

export default () => {
    App.start({
        css: style,
        instanceName: 'lock',

        requestHandler(js, res) {
            App.eval(js).then(res).catch(res);
        },

        main: () => {
            Lockscreen();
        },
    });
};

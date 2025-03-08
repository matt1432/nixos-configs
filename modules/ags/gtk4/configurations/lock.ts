import { App } from 'astal/gtk4';

import Lockscreen from '../widgets/lockscreen';

import style from '../style.scss';


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

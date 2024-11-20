import { App } from 'astal/gtk3';

import Lockscreen from '../widgets/lockscreen/main';

import style from '../style/lock.scss';


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

import { subprocess } from 'astal';
import { App } from 'astal/gtk3';

import Greeter from '../widgets/greeter/main';

import style from '../style/greeter.scss';


export default () => {
    App.start({
        css: style,
        instanceName: 'greeter',

        main: () => {
            Greeter(subprocess('hyprpaper'));
        },
    });
};

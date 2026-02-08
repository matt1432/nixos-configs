import { subprocess } from 'astal';
import { App } from 'astal/gtk3';

import style from '../style/greeter.scss';
import Greeter from '../widgets/greeter';

export default () => {
    App.start({
        css: style,
        instanceName: 'greeter',

        main: () => {
            Greeter(subprocess('hyprpaper'));
        },
    });
};

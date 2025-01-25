import { App } from 'astal/gtk4';

import style from './style.scss';

// import Bar from './widgets/bar';
import Lockscreen from './widgets/lockscreen';


App.start({
    css: style,
    instanceName: 'gtk4',

    main() {
        // Bar();
        Lockscreen();
    },
});

import { App } from 'astal';

import style from './style.scss';

import Bar from './widgets/bar/wim';
import BgFade from './widgets/bg-fade/main';


App.start({
    css: style,

    main: () => {
        Bar();
        BgFade();
    },
});

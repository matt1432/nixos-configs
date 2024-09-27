import { App } from 'astal';

import style from './style.scss';

import Bar from './widgets/bar/wim';


App.start({
    css: style,

    main: () => {
        Bar();
    },
});

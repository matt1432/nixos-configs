import { App } from 'astal';

import style from 'inline:./style.scss';

import Bar from './widgets/bar/main';


App.start({
    css: style,

    main: () => {
        Bar();
    },
});

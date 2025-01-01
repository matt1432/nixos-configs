import { App } from 'astal/gtk4';

import style from './style.scss';

import Bar from './widget/bar';


App.start({
    css: style,
    instanceName: 'gtk4',

    main() {
        Bar();
    },
});

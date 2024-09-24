import { App } from 'astal';
import style from 'inline:./style.scss';
import Bar from './widget/Bar';

App.start({
    css: style,
    main() {
        Bar(0);
    },
});

import { App } from 'astal/gtk3';

import style from './style.scss';

import Bar from './widgets/bar/wim';
import BgFade from './widgets/bg-fade/main';
import Corners from './widgets/corners/main';
import { NotifPopups } from './widgets/notifs/main';

import MonitorClicks from './services/monitor-clicks';


App.start({
    css: style,

    main: () => {
        Bar();
        BgFade();
        Corners();
        NotifPopups();

        new MonitorClicks();
    },
});

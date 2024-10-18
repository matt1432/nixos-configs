import { App } from 'astal/gtk3';

import style from './style.scss';

import AppLauncher from './widgets/applauncher/main';
import Bar from './widgets/bar/wim';
import BgFade from './widgets/bg-fade/main';
import Corners from './widgets/corners/main';
import { NotifPopups, NotifCenter } from './widgets/notifs/main';

import MonitorClicks from './services/monitor-clicks';


App.start({
    css: style,

    main: () => {
        AppLauncher();
        Bar();
        BgFade();
        Corners();
        NotifPopups();
        NotifCenter();

        new MonitorClicks();
    },
});

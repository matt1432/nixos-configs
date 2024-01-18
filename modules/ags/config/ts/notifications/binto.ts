import { Window } from 'resource:///com/github/Aylur/ags/widget.js';

import NotifCenterWidget from './center.ts';
import PopUpsWidget from './popup.ts';

import PopupWindow from '../misc/popup.ts';


export const NotifPopups = () => Window({
    name: 'notifications',
    anchor: ['bottom', 'left'],
    monitor: 1,

    child: PopUpsWidget(),
});


export const NotifCenter = () => PopupWindow({
    name: 'notification-center',
    anchor: ['bottom', 'right'],
    transition: 'slide_up',
    monitor: 1,

    child: NotifCenterWidget(),
});

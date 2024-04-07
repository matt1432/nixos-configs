const { Window } = Widget;

import NotifCenterWidget from './center.ts';
import PopUpsWidget from './popup.ts';

import PopupWindow from '../misc/popup.ts';


export const NotifPopups = () => Window({
    name: 'notifications',
    anchor: ['bottom', 'left'],
    layer: 'overlay',
    monitor: 1,

    child: PopUpsWidget(),
});


export const NotifCenter = () => PopupWindow({
    name: 'notification-center',
    anchor: ['bottom', 'right'],
    transition: 'slide bottom',
    monitor: 1,

    content: NotifCenterWidget(),
});

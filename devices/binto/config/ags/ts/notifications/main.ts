import { Window } from 'resource:///com/github/Aylur/ags/widget.js';

import NotifCenterWidget from '../../wim/ts/notifications/center.ts';
import PopUpsWidget from '../../wim/ts/notifications/popup.ts';

import PopupWindow from '../../wim/ts/misc/popup.ts';


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

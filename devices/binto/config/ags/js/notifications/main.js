import { Window } from 'resource:///com/github/Aylur/ags/widget.js';

import NotifCenterWidget from 'file:///home/matt/.nix/devices/wim/config/ags/js/notifications/center.js';
import PopUpsWidget from 'file:///home/matt/.nix/devices/wim/config/ags/js/notifications/popup.js';

import PopupWindow from 'file:///home/matt/.nix/devices/wim/config/ags/js/misc/popup.js';


export const NotifPopups = () => Window({
    name: 'notifications',
    anchor: ['bottom', 'left'],
    monitor: 1,

    child: PopUpsWidget(),
});


export const NotifCenter = () => PopupWindow({
    name: 'notification-center',
    anchor: ['bottom', 'right'],
    margins: [0, 187, 0, 0],
    transition: 'slide_up',
    monitor: 1,

    child: NotifCenterWidget(),
});

import PopUpsWidget from 'file:///home/matt/.nix/devices/wim/config/ags/js/notifications/popup.js';
import NotifCenterWidget from 'file:///home/matt/.nix/devices/wim/config/ags/js/notifications/center.js';

import PopupWindow from 'file:///home/matt/.nix/devices/wim/config/ags/js/misc/popup.js';


export const NotifPopups = () => PopupWindow({
    name: 'notifications',
    anchor: ['bottom', 'left'],
    visible: true,
    transition: 'none',
    closeOnUnfocus: 'stay',
    monitor: 1,

    child: PopUpsWidget(),
});


export const NotifCenter = () => PopupWindow({
    name: 'notification-center',
    anchor: ['bottom', 'right'],
    margins: [0, 169, 0, 0],
    transition: 'slide_up',
    monitor: 1,

    child: NotifCenterWidget(),
});

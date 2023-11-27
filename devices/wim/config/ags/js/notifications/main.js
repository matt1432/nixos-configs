import PopUpsWidget from './popup.js';
import NotifCenterWidget from './center.js';

import PopupWindow from '../misc/popup.js';

export const NotifPopups = () => PopupWindow({
    name: 'notifications',
    anchor: ['top', 'left'],
    visible: true,
    transition: 'none',
    closeOnUnfocus: 'stay',

    child: PopUpsWidget(),
});


const TOP_MARGIN = 6;
const RIGHT_MARGIN = 60;

export const NotifCenter = () => PopupWindow({
    name: 'notification-center',
    anchor: ['top', 'right'],
    margins: [TOP_MARGIN, RIGHT_MARGIN, 0, 0],

    child: NotifCenterWidget(),
});

import PopUpsWidget from './popup.js';
import NotifCenterWidget from './center.js';

import PopupWindow from '../misc/popup.js';

export const NotifPopups = () => PopupWindow({
    name: 'notifications',
    anchor: ['top', 'left'],
    visible: true,
    transition: 'none',
    close_on_unfocus: 'stay',

    child: PopUpsWidget(),
});


const TOP_MARGIN = 6;

export const NotifCenter = () => PopupWindow({
    name: 'notification-center',
    anchor: ['top', 'right'],
    margins: [TOP_MARGIN, 0, 0, 0],

    child: NotifCenterWidget(),
});

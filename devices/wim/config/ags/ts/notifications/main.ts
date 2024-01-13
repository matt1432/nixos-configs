import { Window } from 'resource:///com/github/Aylur/ags/widget.js';
import NotifCenterWidget from './center.js';
import PopUpsWidget from './popup.js';

import PopupWindow from '../misc/popup.js';

export const NotifPopups = () => Window({
    name: 'notifications',
    anchor: ['top', 'left'],
    child: PopUpsWidget(),
});


const TOP_MARGIN = 6;

export const NotifCenter = () => PopupWindow({
    name: 'notification-center',
    anchor: ['top', 'right'],
    margins: [TOP_MARGIN, 0, 0, 0],

    child: NotifCenterWidget(),
});

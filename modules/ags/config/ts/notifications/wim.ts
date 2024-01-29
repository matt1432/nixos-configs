import { Window } from 'resource:///com/github/Aylur/ags/widget.js';
import NotifCenterWidget from './center.ts';
import PopUpsWidget from './popup.ts';

import PopupWindow from '../misc/popup.ts';

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

    content: NotifCenterWidget(),
});

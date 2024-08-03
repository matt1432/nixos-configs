const { Window } = Widget;

import NotifCenterWidget from './center.ts';
import PopUpsWidget from './popup.ts';

import PopupWindow from '../misc/popup.ts';
import { get_gdkmonitor_from_desc } from '../lib.ts';


export const NotifPopups = () => Window({
    name: 'notifications',
    anchor: ['bottom', 'left'],
    layer: 'overlay',
    gdkmonitor: get_gdkmonitor_from_desc('desc:Acer Technologies Acer K212HQL T3EAA0014201'),

    child: PopUpsWidget(),
});


export const NotifCenter = () => PopupWindow({
    name: 'notification-center',
    anchor: ['bottom', 'right'],
    transition: 'slide bottom',
    gdkmonitor: get_gdkmonitor_from_desc('desc:Acer Technologies Acer K212HQL T3EAA0014201'),

    child: NotifCenterWidget(),
});

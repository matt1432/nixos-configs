import PopupWindow from '../misc/popup.ts';
import CalendarWidget from './main.ts';
import { get_gdkmonitor_from_desc } from '../lib.ts';


const RIGHT_MARGIN = 20;

export default () => PopupWindow({
    name: 'calendar',
    anchor: ['bottom', 'right'],
    margins: [0, RIGHT_MARGIN, 0, 0],
    transition: 'slide bottom',
    gdkmonitor: get_gdkmonitor_from_desc('desc:Acer Technologies Acer K212HQL T3EAA0014201'),

    child: CalendarWidget(),
});

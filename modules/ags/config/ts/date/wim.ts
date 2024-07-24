import PopupWindow from '../misc/popup.ts';
import CalendarWidget from './main.ts';

const TOP_MARGIN = 6;

export default () => PopupWindow({
    name: 'calendar',
    anchor: ['top'],
    margins: [TOP_MARGIN, 0, 0, 0],

    child: CalendarWidget(),
});

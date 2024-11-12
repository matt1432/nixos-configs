import { Astal } from 'astal/gtk3';

import PopupWindow from '../misc/popup-window';
import { get_gdkmonitor_from_desc } from '../../lib';

import DateWidget from './main';


export default () => (
    <PopupWindow
        name="calendar"
        gdkmonitor={get_gdkmonitor_from_desc('desc:Acer Technologies Acer K212HQL T3EAA0014201')}
        anchor={Astal.WindowAnchor.BOTTOM}
        transition="slide bottom"
    >
        <DateWidget />
    </PopupWindow>
);

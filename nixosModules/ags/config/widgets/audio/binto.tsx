import { Astal } from 'astal/gtk3';

import PopupWindow from '../misc/popup-window';
import { get_gdkmonitor_from_desc } from '../../lib';

import AudioWidget from './main';


export default () => (
    <PopupWindow
        name="audio"
        gdkmonitor={get_gdkmonitor_from_desc('desc:Acer Technologies Acer K212HQL T3EAA0014201')}
        anchor={Astal.WindowAnchor.RIGHT | Astal.WindowAnchor.TOP}
        transition="slide bottom"
    >
        <AudioWidget />
    </PopupWindow>
);

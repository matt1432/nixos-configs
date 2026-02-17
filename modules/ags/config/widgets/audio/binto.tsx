import { Astal } from 'ags/gtk3';

import { get_gdkmonitor_from_desc } from '../../lib';
import PopupWindow from '../misc/popup-window';
import AudioWidget from './main';

export default () => (
    <PopupWindow
        name="audio"
        gdkmonitor={get_gdkmonitor_from_desc(
            'desc:GIGA-BYTE TECHNOLOGY CO. LTD. G27QC 0x00000B1D',
        )}
        anchor={Astal.WindowAnchor.RIGHT | Astal.WindowAnchor.BOTTOM}
        transition="slide bottom"
    >
        <AudioWidget />
    </PopupWindow>
);

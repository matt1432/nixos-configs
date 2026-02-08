import { Astal } from 'astal/gtk3';

import { get_gdkmonitor_from_desc } from '../../lib';
import PopupWindow from '../misc/popup-window';
import Center from './center';
import Popups from './popups';

export const NotifPopups = () => (
    <window
        name="notifications"
        namespace="noanim-notifications"
        gdkmonitor={get_gdkmonitor_from_desc(
            'desc:GIGA-BYTE TECHNOLOGY CO. LTD. G27QC 0x00000B1D',
        )}
        layer={Astal.Layer.OVERLAY}
        anchor={Astal.WindowAnchor.BOTTOM | Astal.WindowAnchor.LEFT}
    >
        <Popups />
    </window>
);

export const NotifCenter = () => (
    <PopupWindow
        name="notif-center"
        gdkmonitor={get_gdkmonitor_from_desc(
            'desc:GIGA-BYTE TECHNOLOGY CO. LTD. G27QC 0x00000B1D',
        )}
        anchor={Astal.WindowAnchor.BOTTOM | Astal.WindowAnchor.RIGHT}
        transition="slide bottom"
    >
        <Center />
    </PopupWindow>
);

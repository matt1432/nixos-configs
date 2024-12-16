import { Astal } from 'astal/gtk3';

import PopupWindow from '../misc/popup-window';
import { get_gdkmonitor_from_desc } from '../../lib';

import Popups from './popups';
import Center from './center';


export const NotifPopups = () => (
    <window
        name="notifications"
        namespace="noanim-notifications"
        gdkmonitor={get_gdkmonitor_from_desc('desc:Acer Technologies Acer K212HQL T3EAA0014201')}
        layer={Astal.Layer.OVERLAY}
        anchor={Astal.WindowAnchor.BOTTOM | Astal.WindowAnchor.LEFT}
    >
        <Popups />
    </window>
);

export const NotifCenter = () => (
    <PopupWindow
        name="notif-center"
        gdkmonitor={get_gdkmonitor_from_desc('desc:Acer Technologies Acer K212HQL T3EAA0014201')}
        anchor={Astal.WindowAnchor.BOTTOM | Astal.WindowAnchor.RIGHT}
        transition="slide bottom"
    >
        <Center />
    </PopupWindow>
);

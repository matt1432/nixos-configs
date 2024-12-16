import { Astal } from 'astal/gtk3';

import PopupWindow from '../misc/popup-window';

import Popups from './popups';
import Center from './center';


export const NotifPopups = () => (
    <window
        name="notifications"
        namespace="notifications"
        layer={Astal.Layer.OVERLAY}
        anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.LEFT}
    >
        <Popups />
    </window>
);

export const NotifCenter = () => (
    <PopupWindow
        name="notif-center"
        anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.RIGHT}
    >
        <Center />
    </PopupWindow>
);

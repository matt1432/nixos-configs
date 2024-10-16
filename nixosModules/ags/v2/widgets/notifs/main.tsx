import { Astal } from 'astal/gtk3';

import Popups from './popups';


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

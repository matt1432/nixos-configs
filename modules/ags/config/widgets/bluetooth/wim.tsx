import { Astal } from 'astal/gtk3';

import PopupWindow from '../misc/popup-window';
import BluetoothWidget from './main';

export default () => (
    <PopupWindow
        name="bluetooth"
        anchor={Astal.WindowAnchor.RIGHT | Astal.WindowAnchor.TOP}
    >
        <BluetoothWidget />
    </PopupWindow>
);

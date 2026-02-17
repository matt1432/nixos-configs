import { Astal } from 'ags/gtk3';

import PopupWindow from '../misc/popup-window';
import AudioWidget from './main';

export default () => (
    <PopupWindow
        name="audio"
        anchor={Astal.WindowAnchor.RIGHT | Astal.WindowAnchor.TOP}
    >
        <AudioWidget />
    </PopupWindow>
);

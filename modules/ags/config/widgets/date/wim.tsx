import { Astal } from 'ags/gtk4';

import PopupWindow from '../misc/popup-window';
import DateWidget from './main';

export default () => (
    <PopupWindow name="calendar" anchor={Astal.WindowAnchor.TOP}>
        <DateWidget />
    </PopupWindow>
);

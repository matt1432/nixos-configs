import { Astal } from 'astal/gtk3';

import PopupWindow from '../misc/popup-window';

import NetworkWidget from './main';


export default () => (
    <PopupWindow
        name="network"
        anchor={Astal.WindowAnchor.RIGHT | Astal.WindowAnchor.TOP}
    >
        <NetworkWidget />
    </PopupWindow>
);

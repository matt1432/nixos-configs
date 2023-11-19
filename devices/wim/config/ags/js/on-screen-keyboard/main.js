import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

import Gesture from './gesture.js';
import Keyboard from './keyboard.js';
import PopupWindow from '../misc/popup.js';


// ydotool stuff
execAsync('ydotoold').catch(print);

function releaseAllKeys() {
    const keycodes = Array.from(Array(249).keys());
    execAsync(['ydotool', 'key', ...keycodes.map(keycode => `${keycode}:0`)])
        .then(console.log('Released all keys'))
        .catch(print);
}

// Window
export default () => Gesture(PopupWindow({
    name: 'osk',
    exclusivity: 'exclusive',
    anchor: ['left', 'bottom', 'right'],
    onClose: releaseAllKeys,
    closeOnUnfocus: 'none',
    connections: [[Tablet, self => {
        self.visible = Tablet.oskState;
    }, 'osk-toggled']],
    child: Keyboard(),
}));

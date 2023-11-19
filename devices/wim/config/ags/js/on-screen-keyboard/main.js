import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

import Gesture from './gesture.js';
import Keyboard from './keyboard.js';
import PopupWindow from '../misc/popup.js';


// ydotool stuff
execAsync('ydotoold').catch(print);

function releaseAllKeys() {
    const keycodes = Array.from(Array(249).keys());
    execAsync([
        'ydotool', 'key',
        ...keycodes.map(keycode => `${keycode}:0`),
    ]).catch(print);
}

// Window
export default () => {
    const window = PopupWindow({
        name: 'osk',
        anchor: ['left', 'bottom', 'right'],
        onClose: releaseAllKeys,
        closeOnUnfocus: 'none',
        connections: [[Tablet, self => {
            self.visible = Tablet.oskState;
        }, 'osk-toggled']],
    });
    window.setChild(Keyboard(window));

    return Gesture(window);
};

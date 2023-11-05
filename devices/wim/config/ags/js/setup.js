import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

import Tablet        from '../services/tablet.js';
import Pointers      from '../services/pointers.js';
import TouchGestures from '../services/touch-gestures.js';
import closeAll from './misc/closer.js';


export default () => {
    globalThis.Tablet = Tablet;
    globalThis.Pointers = Pointers;
    globalThis.closeAll = closeAll;

    execAsync(['bash', '-c', '$AGS_PATH/startup.sh']).catch(print);

    TouchGestures.addGesture({
        name: 'oskOn',
        gesture: 'DU',
        edge: 'B',
        command: 'busctl call --user sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 SetVisible b true',
    });

    TouchGestures.addGesture({
        name: 'oskOff',
        gesture: 'UD',
        edge: 'B',
        command: 'busctl call --user sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 SetVisible b false',
    });

    TouchGestures.addGesture({
        name: 'swipeSpotify1',
        gesture: 'LR',
        edge: 'L',
        command: 'hyprctl dispatch togglespecialworkspace spot',
    });

    TouchGestures.addGesture({
        name: 'swipeSpotify2',
        gesture: 'RL',
        edge: 'L',
        command: 'hyprctl dispatch togglespecialworkspace spot',
    });
};

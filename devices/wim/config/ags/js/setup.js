import App from 'resource:///com/github/Aylur/ags/app.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

import Brightness from '../services/brightness.js';
import Pointers from '../services/pointers.js';
import Tablet from '../services/tablet.js';
import TouchGestures from '../services/touch-gestures.js';
import closeAll from './misc/closer.js';


export default () => {
    globalThis.Brightness = Brightness;
    globalThis.Pointers = Pointers;
    globalThis.Tablet = Tablet;
    globalThis.closeAll = closeAll;

    TouchGestures.addGesture({
        name: 'openAppLauncher',
        gesture: 'UD',
        edge: 'T',
        command: () => App.openWindow('applauncher'),
    });

    TouchGestures.addGesture({
        name: 'oskOn',
        gesture: 'DU',
        edge: 'B',
        command: 'busctl call --user sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 ' +
            'SetVisible b true',
    });

    TouchGestures.addGesture({
        name: 'oskOff',
        gesture: 'UD',
        edge: 'B',
        command: 'busctl call --user sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 ' +
            'SetVisible b false',
    });

    TouchGestures.addGesture({
        name: 'swipeSpotify1',
        gesture: 'LR',
        edge: 'L',
        command: () => Hyprland.sendMessage(
            'dispatch togglespecialworkspace spot',
        ),
    });

    TouchGestures.addGesture({
        name: 'swipeSpotify2',
        gesture: 'RL',
        edge: 'L',
        command: () => Hyprland.sendMessage(
            'dispatch togglespecialworkspace spot',
        ),
    });
};

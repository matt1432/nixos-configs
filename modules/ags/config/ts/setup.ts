const Hyprland = await Service.import('hyprland');
const Bluetooth = await Service.import('bluetooth');

import Brightness from '../services/brightness.ts';
import Pointers from '../services/pointers.ts';
import Tablet from '../services/tablet.ts';
import TouchGestures from '../services/touch-gestures.ts';

import closeAll from './misc/closer.ts';
import Persist from './misc/persist.ts';


export default () => {
    globalThis.Brightness = Brightness;
    globalThis.Pointers = Pointers;
    globalThis.Tablet = Tablet;
    globalThis.closeAll = closeAll;

    Persist({
        name: 'bluetooth',
        gobject: Bluetooth,
        prop: 'enabled',
        signal: 'notify::enabled',
    });

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
        command: () => Hyprland.messageAsync(
            'dispatch togglespecialworkspace spot',
        ),
    });

    TouchGestures.addGesture({
        name: 'swipeSpotify2',
        gesture: 'RL',
        edge: 'L',
        command: () => Hyprland.messageAsync(
            'dispatch togglespecialworkspace spot',
        ),
    });
};

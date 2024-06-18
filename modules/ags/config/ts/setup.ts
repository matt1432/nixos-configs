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
        command: () => App.openWindow('win-applauncher'),
    });

    TouchGestures.addGesture({
        name: 'oskOn',
        gesture: 'DU',
        edge: 'B',
        command: () => {
            Tablet.oskState = true;
        },
    });

    TouchGestures.addGesture({
        name: 'oskOff',
        gesture: 'UD',
        edge: 'B',
        command: () => {
            Tablet.oskState = false;
        },
    });

    TouchGestures.addGesture({
        name: 'openOverview',
        nFingers: '3',
        gesture: 'UD',
        command: 'hyprctl dispatch hyprexpo:expo on',
    });
};

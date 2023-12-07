import App from 'resource:///com/github/Aylur/ags/app.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Bluetooth from 'resource:///com/github/Aylur/ags/service/bluetooth.js';
import { execAsync, readFileAsync, timeout } from 'resource:///com/github/Aylur/ags/utils.js';

const { get_home_dir } = imports.gi.GLib;

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

    // Persist Bluetooth state
    const bluetoothFile = `${get_home_dir()}/.cache/ags/.bluetooth`;
    const stateCmd = () => ['bash', '-c',
        `echo ${Bluetooth.enabled} > ${bluetoothFile}`];
    const monitorState = () => {
        Bluetooth.connect('notify::enabled', () => {
            execAsync(stateCmd()).catch(print);
        });
    };

    // On launch
    readFileAsync(bluetoothFile).then((content) => {
        Bluetooth.enabled = JSON.parse(content);
        timeout(1000, () => {
            monitorState();
        });
    }).catch(() => {
        execAsync(stateCmd()).then(() => {
            monitorState();
        }).catch(print);
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

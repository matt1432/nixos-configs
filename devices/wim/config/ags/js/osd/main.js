import App from 'resource:///com/github/Aylur/ags/app.js';

import { timeout } from 'resource:///com/github/Aylur/ags/utils.js';
import { Stack } from 'resource:///com/github/Aylur/ags/widget.js';

import GLib from 'gi://GLib';
import PopupWindow from '../misc/popup.js';

import Audio from './audio.js';
import Brightness from './brightness.js';
import CapsLock from './caps.js';
import Keyboard from './kbd.js';
import Microphone from './mic.js';

const HIDE_DELAY = 2000;


export default () => {
    let setup = 0;

    const stack = Stack({
        css: 'margin-bottom: 80px;',
        items: [
            ['audio', Audio()],
            ['brightness', Brightness()],
            ['caps', CapsLock()],
            ['kbd', Keyboard()],
            ['mic', Microphone()],
        ],
    });

    const window = PopupWindow({
        name: 'osd',
        anchor: ['bottom'],
        exclusivity: 'ignore',
        closeOnUnfocus: 'stay',
        transition: 'slide_up',
        transitionDuration: 200,
        child: stack,
    });

    let timer;

    stack.resetTimer = () => {
        // Each osd calls resetTimer once at startup
        // FIXME: doesn't seem to work anymore, find alternative
        if (setup <= stack.items.length + 1) {
            ++setup;

            return;
        }

        App.openWindow('osd');
        if (timer) {
            GLib.source_remove(timer);
        }

        timer = timeout(HIDE_DELAY, () => {
            App.closeWindow('osd');
            timer = null;
        });
    };

    return window;
};

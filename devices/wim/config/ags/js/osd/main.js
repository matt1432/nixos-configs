import App from 'resource:///com/github/Aylur/ags/app.js';

import { timeout } from 'resource:///com/github/Aylur/ags/utils.js';
import { Stack } from 'resource:///com/github/Aylur/ags/widget.js';

import PopupWindow from '../misc/popup.js';

// Import all the OSDs as an array
const OSDList = [];

import * as Modules from './osds.js';
for (const osd in Modules) {
    OSDList.push(Modules[osd]);
} // Array

const HIDE_DELAY = 2000;


const OSDs = () => {
    const stack = Stack({
        transition: 'over_up_down',
        transitionDuration: 200,
    });

    stack.items = OSDList.map((osd, i) => [`${i}`, osd(stack)]);

    stack.popup = () => { /**/ };

    // Delay popup method so it
    // doesn't show any OSDs at launch
    timeout(1000, () => {
        let count = 0;

        stack.popup = (osd) => {
            ++count;
            stack.set_visible_child(osd);
            App.openWindow('osd');

            timeout(HIDE_DELAY, () => {
                --count;

                if (count === 0) {
                    App.closeWindow('osd');
                }
            });
        };
    });

    return stack;
};

export default () => PopupWindow({
    name: 'osd',
    anchor: ['bottom'],
    exclusivity: 'ignore',
    closeOnUnfocus: 'stay',
    transition: 'slide_up',
    transitionDuration: 200,
    child: OSDs(),
});

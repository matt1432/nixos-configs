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
const transition_duration = 300;


const OSDs = () => {
    const stack = Stack({
        transition: 'over_up_down',
        transition_duration,

        attribute: {
            popup: () => {/**/},
        },
    });

    // Send reference of stack to all items
    stack.items = OSDList.map((osd, i) => [`${i}`, osd(stack)]);

    // Delay popup method so it
    // doesn't show any OSDs at launch
    timeout(1000, () => {
        let count = 0;

        /** @param {import('types/widgets/box').default} osd */
        stack.attribute.popup = (osd) => {
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
    close_on_unfocus: 'stay',
    transition: 'slide_up',
    transition_duration,
    bezier: 'ease',
    child: OSDs(),
});

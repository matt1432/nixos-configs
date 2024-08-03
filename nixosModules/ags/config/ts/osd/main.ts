const { timeout } = Utils;
const { Stack } = Widget;

import PopupWindow from '../misc/popup.ts';

// Types
import { BoxGeneric } from 'global-types';

// Import all the OSDs as an array
const OSDList = [] as (() => BoxGeneric)[];

import * as Modules from './osds.ts';
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
            popup: (osd: string) => {
                if (!osd) {
                    //
                }
            },
        },
    });

    // Send reference of stack to all children
    stack.children = Object.fromEntries(
        OSDList.map((osd) => {
            const widget = osd();

            return [widget.name, widget];
        }),
    );

    stack.show_all();

    // Delay popup method so it
    // doesn't show any OSDs at launch
    timeout(1000, () => {
        let count = 0;

        stack.attribute.popup = (osd: string) => {
            ++count;
            stack.shown = osd;
            App.openWindow('win-osd');

            timeout(HIDE_DELAY, () => {
                --count;

                if (count === 0) {
                    App.closeWindow('win-osd');
                }
            });
        };

        globalThis['popup_osd'] = stack.attribute.popup;
    });

    return stack;
};

export default () => PopupWindow({
    name: 'osd',
    anchor: ['bottom'],
    exclusivity: 'ignore',
    close_on_unfocus: 'stay',
    transition: 'slide bottom',
    child: OSDs(),
});

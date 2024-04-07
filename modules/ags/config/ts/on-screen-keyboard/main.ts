const { Window } = Widget;
const { execAsync } = Utils;

import Tablet from '../../services/tablet.ts';
import Gesture from './gesture.ts';
import Keyboard from './keyboard.ts';

/* Types */
import { OskWindow } from 'global-types';

// Start ydotool daemon
execAsync('ydotoold').catch(print);

// Window
export default () => {
    const window = Window({
        name: 'osk',
        layer: 'overlay',
        anchor: ['left', 'bottom', 'right'],
    })
        .hook(Tablet, (self: OskWindow, state) => {
            self.attribute.setVisible(state);
        }, 'osk-toggled')

        .hook(Tablet, () => {
            window.visible = !(!Tablet.tabletMode && !Tablet.oskState);
        }, 'mode-toggled');

    window.child = Keyboard(window);

    return Gesture(window);
};

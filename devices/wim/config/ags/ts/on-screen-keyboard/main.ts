import { Window } from 'resource:///com/github/Aylur/ags/widget.js';
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

import Tablet from '../../services/tablet.ts';
import Gesture from './gesture.ts';
import Keyboard from './keyboard.ts';


// Start ydotool daemon
execAsync('ydotoold').catch(print);

// Window
export default () => {
    const window = Window({
        name: 'osk',
        visible: false,
        layer: 'overlay',
        anchor: ['left', 'bottom', 'right'],

        setup: (self) => {
            self
                .hook(Tablet, (_, state) => {
                    self.attribute.setVisible(state);
                }, 'osk-toggled')

                .hook(Tablet, () => {
                    if (!Tablet.tabletMode && !Tablet.oskState) {
                        window.visible = false;
                    }
                }, 'mode-toggled');
        },
    });

    window.child = Keyboard(window);

    return Gesture(window);
};

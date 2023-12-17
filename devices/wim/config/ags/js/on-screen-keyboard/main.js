import { Window } from 'resource:///com/github/Aylur/ags/widget.js';
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

import Tablet from '../../services/tablet.js';
import Gesture from './gesture.js';
import Keyboard from './keyboard.js';


// Start ydotool daemon
execAsync('ydotoold').catch(print);

// Window
export default () => {
    const window = Window({
        name: 'osk',
        visible: false,
        anchor: ['left', 'bottom', 'right'],

        setup: (self) => {
            self
                .hook(Tablet, (_, state) => {
                    self.setVisible(state);
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

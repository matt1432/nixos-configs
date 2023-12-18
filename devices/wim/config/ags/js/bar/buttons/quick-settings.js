import App from 'resource:///com/github/Aylur/ags/app.js';

import { Box, Label } from 'resource:///com/github/Aylur/ags/widget.js';

import Audio from './audio.js';
import Bluetooth from './bluetooth.js';
import Brightness from './brightness.js';
import KeyboardLayout from './keyboard-layout.js';
import Network from './network.js';

import EventBox from '../../misc/cursorbox.js';
import Separator from '../../misc/separator.js';

const SPACING = 4;


export default () => EventBox({
    className: 'toggle-off',

    onHoverLost: () => { /**/ },

    onPrimaryClickRelease: (self) => {
        // @ts-expect-error
        App.getWindow('notification-center').setXPos(
            self.get_allocation(),
            'right',
        );

        App.toggleWindow('quick-settings');
    },

    setup: (self) => {
        self.hook(App, (_, windowName, visible) => {
            if (windowName === 'quick-settings') {
                self.toggleClassName('toggle-on', visible);
            }
        });
    },

    child: Box({
        class_name: 'quick-settings-toggle',
        vertical: false,
        children: [
            Separator(SPACING),

            KeyboardLayout(),

            Brightness(),

            Audio(),

            Bluetooth(),

            Network(),

            Label(' '),

            Separator(SPACING),
        ],
    }),
});

import { Box, Icon, ProgressBar } from 'resource:///com/github/Aylur/ags/widget.js';

import Brightness from '../../services/brightness.js';


export default () => Box({
    className: 'osd',

    children: [
        Icon({
            hpack: 'start',
            icon: 'keyboard-brightness-symbolic',
        }),

        ProgressBar({
            vpack: 'center',

            connections: [[Brightness, (self) => {
                if (!self.value) {
                    self.value = Brightness.kbd / 2;

                    return;
                }
                self.value = Brightness.kbd / 2;
                self.sensitive = Brightness.kbd !== 0;

                const stack = self.get_parent().get_parent();

                stack.shown = 'kbd';
                stack.resetTimer();
            }, 'kbd']],
        }),
    ],
});

import { Box, Label } from 'resource:///com/github/Aylur/ags/widget.js';
import { subprocess, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

import EventBox from '../../misc/cursorbox.js';


export default () => EventBox({
    hpack: 'center',

    onPrimaryClickRelease: () => {
        execAsync(['bash', '-c', '$AGS_PATH/heart.sh toggle']).catch(print);
    },

    child: Box({
        className: 'heart-toggle',
        vertical: false,

        child: Label({
            label: '',
            setup: self => {
                subprocess(
                    ['bash', '-c', 'tail -f /home/matt/.config/.heart'],
                    output => self.label = ' ' + output,
                );
            },
        }),
    }),
});

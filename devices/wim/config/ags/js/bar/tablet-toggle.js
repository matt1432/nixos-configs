import { Box, Label } from 'resource:///com/github/Aylur/ags/widget.js';
import { subprocess } from 'resource:///com/github/Aylur/ags/utils.js';

import EventBox from '../misc/cursorbox.js';


export default () => EventBox({
    className: 'toggle-off',
    onPrimaryClickRelease: self => {
        subprocess(
            ['bash', '-c', '$AGS_PATH/tablet-toggle.sh toggle'],
            output => self.toggleClassName('toggle-on', output == 'Tablet'),
        );
    },
    child: Box({
        className: 'tablet-toggle',
        vertical: false,
        child: Label({
            label: ' 󰦧 ',
        }),
    }),
});

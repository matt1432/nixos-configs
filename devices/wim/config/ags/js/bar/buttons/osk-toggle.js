import { Box, Label } from 'resource:///com/github/Aylur/ags/widget.js';

import Tablet from '../../../services/tablet.js';
import EventBox from '../../misc/cursorbox.js';


export default () => EventBox({
    className: 'toggle-off',

    onPrimaryClickRelease: () => Tablet.toggleOsk(),

    setup: (self) => {
        self.hook(Tablet, () => {
            self.toggleClassName('toggle-on', Tablet.oskState);
        }, 'osk-toggled');
    },

    child: Box({
        className: 'osk-toggle',
        children: [Label(' 󰌌 ')],
    }),
});

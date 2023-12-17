import { Box, Label } from 'resource:///com/github/Aylur/ags/widget.js';

import Tablet from '../../../services/tablet.js';
import EventBox from '../../misc/cursorbox.js';


export default () => EventBox({
    className: 'toggle-off',

    onPrimaryClickRelease: () => Tablet.toggleMode(),

    setup: (self) => {
        self.hook(Tablet, () => {
            self.toggleClassName('toggle-on', Tablet.tabletMode);
        }, 'mode-toggled');
    },

    child: Box({
        className: 'tablet-toggle',
        vertical: false,
        children: [Label(' 󰦧 ')],
    }),
});

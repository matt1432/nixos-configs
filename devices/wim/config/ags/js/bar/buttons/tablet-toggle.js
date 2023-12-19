import { Box, Label } from 'resource:///com/github/Aylur/ags/widget.js';

import Tablet from '../../../services/tablet.js';
import CursorBox from '../../misc/cursorbox.js';


export default () => CursorBox({
    class_name: 'toggle-off',

    on_primary_click_release: () => Tablet.toggleMode(),

    child: Box({
        class_name: 'tablet-toggle',
        vertical: false,
        children: [Label(' 󰦧 ')],
    }),

}).hook(Tablet, (self) => {
    self.toggleClassName('toggle-on', Tablet.tabletMode);
}, 'mode-toggled');

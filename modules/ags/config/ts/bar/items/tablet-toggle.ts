const { Box, Label } = Widget;

import Tablet from '../../../services/tablet.ts';
import CursorBox from '../../misc/cursorbox.ts';


export default () => CursorBox({
    class_name: 'toggle-off',

    on_primary_click_release: () => Tablet.toggleMode(),

    setup: (self) => {
        self.hook(Tablet, () => {
            self.toggleClassName('toggle-on', Tablet.tabletMode);
        }, 'mode-toggled');
    },

    child: Box({
        class_name: 'tablet-toggle',
        vertical: false,
        children: [Label(' 󰦧 ')],
    }),

});

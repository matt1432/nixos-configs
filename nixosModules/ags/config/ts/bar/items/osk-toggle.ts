const { Label } = Widget;

import Tablet from '../../../services/tablet.ts';
import CursorBox from '../../misc/cursorbox.ts';


export default () => CursorBox({
    class_name: 'toggle-off',

    on_primary_click_release: () => Tablet.toggleOsk(),

    setup: (self) => {
        self.hook(Tablet, () => {
            self.toggleClassName('toggle-on', Tablet.oskState);
        }, 'osk-toggled');
    },

    child: Label({
        class_name: 'osk-toggle',
        xalign: 0.6,
        label: '󰌌 ',
    }),
});

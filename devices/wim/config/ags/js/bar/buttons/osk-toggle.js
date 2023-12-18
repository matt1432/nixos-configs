import { Label } from 'resource:///com/github/Aylur/ags/widget.js';

import Tablet from '../../../services/tablet.js';
import EventBox from '../../misc/cursorbox.js';


export default () => EventBox({
    className: 'toggle-off',

    onPrimaryClickRelease: () => Tablet.toggleOsk(),

    child: Label({
        class_name: 'osk-toggle',
        xalign: 0.6,
        label: '󰌌 ',
    }),

}).hook(Tablet, (self) => {
    self.toggleClassName('toggle-on', Tablet.oskState);
}, 'osk-toggled');

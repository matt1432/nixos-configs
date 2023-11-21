import { ProgressBar, Overlay, Box } from 'resource:///com/github/Aylur/ags/widget.js';

import Brightness from '../../../services/brightness.js';
import Separator from '../../misc/separator.js';
import Heart from './heart.js';

const SPACING = 25;
const BAR_CUTOFF = 0.33;


export default () => Overlay({
    tooltipText: 'Brightness',

    child: ProgressBar({
        className: 'toggle-off brightness',
        connections: [[Brightness, (self) => {
            self.value = Brightness.screen > BAR_CUTOFF ?
                Brightness.screen :
                BAR_CUTOFF;
        }, 'screen']],
    }),

    overlays: [
        Box({
            css: 'color: #CBA6F7;',
            children: [
                Separator(SPACING),
                Heart(),
            ],
        }),
    ],
});

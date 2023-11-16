import { ProgressBar, Overlay, Box } from 'resource:///com/github/Aylur/ags/widget.js';

import Separator from '../../misc/separator.js';
import Heart     from './heart.js';


export default () => Overlay({
    tooltipText: 'Brightness',
    child: ProgressBar({
        className: 'toggle-off brightness',
        connections: [[Brightness, self => {
            self.value = Brightness.screen > 0.33 ? Brightness.screen : 0.33;
        }, 'screen']],
    }),
    overlays: [
        Box({
            css: 'color: #CBA6F7;',
            children: [
                Separator(25),
                Heart(),
            ],
        }),
    ],
});

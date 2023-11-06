import { ProgressBar, Overlay, Box } from 'resource:///com/github/Aylur/ags/widget.js';
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

import Separator from '../misc/separator.js';
import Heart     from './heart.js';


export default () => Overlay({
    tooltipText: 'Brightness',
    child: ProgressBar({
        className: 'toggle-off brightness',
        connections: [
            [200, self => {
                execAsync('brightnessctl get').then(out => {
                    const br = out / 255;
                    if (br > 0.33)
                        self.value = br;
                    else
                        self.value = 0.33;
                }).catch(print);
            }],
        ],
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

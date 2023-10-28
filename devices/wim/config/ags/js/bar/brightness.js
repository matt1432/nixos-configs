import { Utils, Widget } from '../../imports.js';
const { ProgressBar, Overlay, Box } = Widget;

import Separator from '../misc/separator.js';
import Heart     from './heart.js';


export default () => Overlay({
    tooltipText: 'Brightness',
    child: ProgressBar({
        className: 'toggle-off brightness',
        connections: [
            [200, self => {
                Utils.execAsync('brightnessctl get').then(out => {
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
            style: 'color: #CBA6F7;',
            children: [
                Separator(25),
                Heart(),
            ],
        }),
    ],
});

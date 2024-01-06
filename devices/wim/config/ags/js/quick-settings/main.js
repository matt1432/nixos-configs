import { Box, Label, Revealer } from 'resource:///com/github/Aylur/ags/widget.js';

import ButtonGrid from './button-grid.js';
import SliderBox from './slider-box.js';
import Player from '../media-player/player.js';
import PopupWindow from '../misc/popup.js';
import ToggleButton from './toggle-button.js';


const QuickSettingsWidget = () => {
    const rev = Revealer({
        transition: 'slide_down',
        child: Player(),
    });

    return Box({
        class_name: 'qs-container',
        vertical: true,
        children: [

            Box({
                class_name: 'quick-settings',
                vertical: true,
                children: [

                    Label({
                        label: 'Control Center',
                        class_name: 'title',
                        hpack: 'start',
                        css: `
                            margin-left: 20px;
                            margin-bottom: 30px;
                        `,
                    }),

                    ButtonGrid(),

                    SliderBox(),

                    ToggleButton(rev),

                ],
            }),

            rev,

        ],
    });
};

const TOP_MARGIN = 6;

export default () => PopupWindow({
    name: 'quick-settings',
    anchor: ['top', 'right'],
    margins: [TOP_MARGIN, 0, 0, 0],
    child: QuickSettingsWidget(),
});

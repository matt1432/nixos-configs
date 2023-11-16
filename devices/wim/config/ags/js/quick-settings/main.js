import { Box, Label, Revealer } from 'resource:///com/github/Aylur/ags/widget.js';

import ButtonGrid   from './button-grid.js';
import SliderBox    from './slider-box.js';
import Player       from '../media-player/player.js';
import PopupWindow  from '../misc/popup.js';
import ToggleButton from './toggle-button.js';


const QuickSettingsWidget = () => {
    const rev = Revealer({
        transition: 'slide_down',
        child: Player(),
    });

    return Box({
        className: 'qs-container',
        vertical: true,
        children: [

            Box({
                className: 'quick-settings',
                vertical: true,
                children: [

                    Label({
                        label: 'Control Center',
                        className: 'title',
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

export default () => PopupWindow({
    name: 'quick-settings',
    anchor: ['top', 'right'],
    margins: [6, 5, 0],
    child: QuickSettingsWidget(),
});

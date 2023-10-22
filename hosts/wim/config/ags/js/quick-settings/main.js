import { Widget } from '../../imports.js';
const { Box, Label, Revealer } = Widget;

import ButtonGrid   from './button-grid.js';
import SliderBox    from './slider-box.js';
import Player       from '../media-player/player.js';
import PopupWindow  from '../misc/popup.js';
import ToggleButton from './toggle-button.js';


const QuickSettingsWidget = () => Box({
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
                    halign: 'start',
                    style: 'margin-left: 20px',
                }),

                ButtonGrid(),

                SliderBox(),

                ToggleButton(),

            ],
        }),

        Revealer({
            transition: 'slide_down',
            child: Player(),
        }),

    ],
});

export default () => PopupWindow({
    name: 'quick-settings',
    anchor: ['top', 'right'],
    margin: [6, 5, 0],
    child: QuickSettingsWidget(),
});

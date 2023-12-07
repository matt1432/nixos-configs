import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';

import { Box, Slider, Icon } from 'resource:///com/github/Aylur/ags/widget.js';

import Brightness from '../../services/brightness.js';
import { SpeakerIcon } from '../misc/audio-icons.js';


export default () => Box({
    className: 'slider-box',
    vertical: true,
    hpack: 'center',
    children: [

        Box({
            className: 'slider',
            vpack: 'start',
            hpack: 'center',

            children: [
                Icon({
                    size: 26,
                    className: 'slider-label',
                    binds: [['icon', SpeakerIcon, 'value']],
                }),

                Slider({
                    cursor: 'pointer',
                    vpack: 'center',
                    max: 0.999,
                    draw_value: false,

                    onChange: ({ value }) => {
                        Audio.speaker.volume = value;
                    },

                    connections: [
                        [Audio, (slider) => {
                            slider.value = Audio.speaker?.volume;
                        }, 'speaker-changed'],

                        ['button-press-event', (s) => {
                            s.cursor = 'grabbing';
                        }],
                        ['button-release-event', (s) => {
                            s.cursor = 'pointer';
                        }],
                    ],
                }),
            ],
        }),

        Box({
            className: 'slider',
            vpack: 'start',
            hpack: 'center',

            children: [
                Icon({
                    className: 'slider-label',
                    binds: [['icon', Brightness, 'screen-icon']],
                }),

                Slider({
                    cursor: 'pointer',
                    vpack: 'center',
                    draw_value: false,

                    onChange: ({ value }) => {
                        Brightness.screen = value;
                    },

                    connections: [
                        [Brightness, (slider) => {
                            slider.value = Brightness.screen;
                        }, 'screen'],

                        ['button-press-event', (s) => {
                            s.cursor = 'grabbing';
                        }],
                        ['button-release-event', (s) => {
                            s.cursor = 'pointer';
                        }],
                    ],
                }),
            ],
        }),

    ],
});

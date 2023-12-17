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

                    setup: (self) => {
                        self
                            .hook(Audio, () => {
                                self.value = Audio.speaker?.volume;
                            }, 'speaker-changed')

                            .on('button-press-event', () => {
                                self.cursor = 'grabbing';
                            })

                            .on('button-release-event', () => {
                                self.cursor = 'pointer';
                            });
                    },
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

                    setup: (self) => {
                        self
                            .hook(Brightness, () => {
                                self.value = Brightness.screen;
                            }, 'screen')

                            .on('button-press-event', () => {
                                self.cursor = 'grabbing';
                            })

                            .on('button-release-event', () => {
                                self.cursor = 'pointer';
                            });
                    },
                }),
            ],
        }),

    ],
});

import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';

import { Box, Slider, Icon } from 'resource:///com/github/Aylur/ags/widget.js';

import Brightness from '../../services/brightness.js';
import { SpeakerIcon } from '../misc/audio-icons.js';


export default () => Box({
    class_name: 'slider-box',
    vertical: true,
    hpack: 'center',
    children: [

        Box({
            class_name: 'slider',
            vpack: 'start',
            hpack: 'center',

            children: [
                Icon({
                    size: 26,
                    class_name: 'slider-label',
                    icon: SpeakerIcon.bind(),
                }),

                Slider({
                    cursor: 'pointer',
                    vpack: 'center',
                    max: 0.999,
                    draw_value: false,

                    on_change: ({ value }) => {
                        if (Audio.speaker) {
                            Audio.speaker.volume = value;
                        }
                    },

                    setup: (self) => {
                        self
                            .hook(Audio, () => {
                                self.value = Audio.speaker?.volume || 0;
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
            class_name: 'slider',
            vpack: 'start',
            hpack: 'center',

            children: [
                Icon({
                    class_name: 'slider-label',
                    icon: Brightness.bind('screenIcon'),
                }),

                Slider({
                    cursor: 'pointer',
                    vpack: 'center',
                    draw_value: false,

                    on_change: ({ value }) => {
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

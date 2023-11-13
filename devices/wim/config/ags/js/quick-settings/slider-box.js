import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import { Box, Slider, Icon, EventBox } from 'resource:///com/github/Aylur/ags/widget.js';

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
                    connections: [[Audio, slider => {
                        if (Audio.speaker)
                            slider.value = Audio.speaker.volume;
                    }, 'speaker-changed']],
                    onChange: ({ value }) => Audio.speaker.volume = value,
                    max: 0.999,
                    draw_value: false,
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
                    icon: 'display-brightness-symbolic',
                }),

                EventBox({
                    onHover: box => box.child._canChange = false,
                    onHoverLost: box => box.child._canChange = true,
                    child: Slider({
                        properties: [
                            ['canChange', true],
                        ],
                        onChange: ({ value }) => {
                            Brightness.screen = value;
                        },
                        connections: [[Brightness, slider => {
                            if (slider._canChange)
                                slider.value = Brightness.screen;
                        }, 'screen']],
                        draw_value: false,
                    }),
                }),
            ],
        }),

    ],
});

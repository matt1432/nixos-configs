import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import { Box, Slider, Icon, EventBox } from 'resource:///com/github/Aylur/ags/widget.js';

const items = {
    101: 'audio-volume-overamplified-symbolic',
    67: 'audio-volume-high-symbolic',
    34: 'audio-volume-medium-symbolic',
    1: 'audio-volume-low-symbolic',
    0: 'audio-volume-muted-symbolic',
};


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
                    connections: [[Audio, icon => {
                        if (Audio.speaker) {
                            if (Audio.speaker.stream.isMuted) {
                                icon.icon = items[0];
                            }
                            else {
                                const vol = Audio.speaker.volume * 100;
                                for (const threshold of [-1, 0, 33, 66, 100]) {
                                    if (vol > threshold + 1)
                                        icon.icon = items[threshold + 1];
                                }
                            }
                        }
                    }, 'speaker-changed']],
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

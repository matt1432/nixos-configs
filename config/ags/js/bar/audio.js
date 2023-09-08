const { Audio } = ags.Service;
const { Label, Box, Icon, Stack, Button, Slider } = ags.Widget;
import { Separator } from '../common.js';

const iconSubstitute = item => {
    const substitues = [
        { from: 'audio-headset-bluetooth', to: 'audio-headphones-symbolic' },
        { from: 'audio-card-analog-usb', to: 'audio-speakers-symbolic' },
        { from: 'audio-card-analog-pci', to: 'audio-card-symbolic' },
    ];

    for (const { from, to } of substitues) {
        if (from === item)
            return to;
    }
    return item;
};

export const SpeakerIndicator = ({
    items = [
        ['101', Icon('audio-volume-overamplified-symbolic')],
        ['67', Icon('audio-volume-high-symbolic')],
        ['34', Icon('audio-volume-medium-symbolic')],
        ['1', Icon('audio-volume-low-symbolic')],
        ['0', Icon('audio-volume-muted-symbolic')],
    ],
    ...props
} = {}) => Stack({
    ...props,
    items,
    connections: [[Audio, stack => {
        if (!Audio.speaker)
            return;

        if (Audio.speaker.isMuted)
            return stack.shown = '0';

        const vol = Audio.speaker.volume * 100;
        for (const threshold of [100, 66, 33, 0, -1]) {
            if (vol > threshold + 1)
                return stack.shown = `${threshold + 1}`;
        }
    }, 'speaker-changed']],
});

export const SpeakerTypeIndicator = props => Icon({
    ...props,
    connections: [[Audio, icon => {
        if (Audio.speaker)
            icon.icon = iconSubstitute(Audio.speaker.iconName);
    }]],
});

export const SpeakerPercentLabel = props => Label({
    ...props,
    connections: [[Audio, label => {
        if (!Audio.speaker)
            return;

        label.label = `${Math.floor(Audio.speaker.volume * 100)}%`;
    }, 'speaker-changed']],
});

const AudioModule = () => Box({
  className: 'toggle-off audio',
  children: [
    SpeakerIndicator(),
    Separator(5),
    SpeakerPercentLabel(),
  ],
});

export const AudioIndicator = AudioModule();

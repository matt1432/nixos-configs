const Audio = await Service.import('audio');

const { Label } = Widget;

import OSD from './ctor.ts';

import Brightness from '../../services/brightness.ts';
import { SpeakerIcon } from '../misc/audio-icons.ts';
import { MicIcon } from '../misc/audio-icons.ts';

const AUDIO_MAX = 1.5;


export const SpeakerOSD = () => OSD({
    name: 'speaker',
    icon: SpeakerIcon.bind(),
    info: {
        mod: Audio.speaker,
        signal: ['notify::volume', 'notify::is-muted'],

        logic: (self) => {
            if (!Audio.speaker) {
                return;
            }

            self.value = Audio.speaker ?
                Audio.speaker.volume / AUDIO_MAX :
                0;

            self.sensitive = !Audio.speaker.stream?.is_muted;
        },
    },
});

export const ScreenBrightnessOSD = () => OSD({
    name: 'screen',
    icon: Brightness.bind('screenIcon'),
    info: {
        mod: Brightness,
        signal: 'screen',

        logic: (self) => {
            self.value = Brightness.screen;
        },
    },
});

export const KbdBrightnessOSD = () => OSD({
    name: 'kbd',
    icon: 'keyboard-brightness-symbolic',
    info: {
        mod: Brightness,
        signal: 'kbd',

        logic: (self) => {
            if (!self.value) {
                self.value = Brightness.kbd / 2;

                return;
            }
            self.value = Brightness.kbd / 2;
            self.sensitive = Brightness.kbd !== 0;
        },
    },
});

export const MicOSD = () => OSD({
    name: 'mic',
    icon: MicIcon.bind(),
    info: {
        mod: Audio.microphone,
        signal: ['notify::volume', 'notify::is-muted'],

        logic: (self) => {
            if (!Audio.microphone) {
                return;
            }

            self.value = Audio.microphone ? Audio.microphone.volume : 0;
            self.sensitive = !Audio.microphone.stream?.is_muted;
        },
    },
});

export const CapsLockOSD = () => OSD({
    name: 'caps',
    icon: Brightness.bind('capsIcon'),
    info: {
        mod: Brightness,
        signal: 'caps',
        widget: Label({
            vpack: 'center',
            label: 'Caps Lock',
        }),
    },
});

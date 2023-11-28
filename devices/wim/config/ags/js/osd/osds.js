import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';

import { Label } from 'resource:///com/github/Aylur/ags/widget.js';
import OSD from './ctor.js';

import Brightness from '../../services/brightness.js';
import { SpeakerIcon } from '../misc/audio-icons.js';
import { MicIcon } from '../misc/audio-icons.js';

const AUDIO_MAX = 1.5;


export const SpeakerOSD = (stack) => OSD({
    stack,
    icon: { binds: [['icon', SpeakerIcon, 'value']] },
    info: {
        mod: Audio,
        signal: 'speaker-changed',
        logic: (self) => {
            if (!Audio.speaker) {
                return;
            }

            self.value = Audio.speaker ?
                Audio.speaker.volume / AUDIO_MAX :
                0;

            self.sensitive = !Audio.speaker?.stream.isMuted;
        },
    },
});

export const ScreenBrightnessOSD = (stack) => OSD({
    stack,
    icon: 'display-brightness-symbolic',
    info: {
        mod: Brightness,
        signal: 'screen',
        logic: (self) => {
            self.value = Brightness.screen;
        },
    },
});

export const KbdBrightnessOSD = (stack) => OSD({
    stack,
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

export const MicOSD = (stack) => OSD({
    stack,
    icon: { binds: [['icon', MicIcon, 'value']] },
    info: {
        mod: Audio,
        signal: 'microphone-changed',
        logic: (self) => {
            if (!Audio.microphone) {
                return;
            }

            self.value = Audio.microphone ? Audio.microphone.volume : 0;
            self.sensitive = !Audio.microphone?.stream.isMuted;
        },
    },
});

export const CapsLockOSD = (stack) => OSD({
    stack,
    icon: { binds: [['icon', Brightness, 'caps-icon']] },
    info: {
        mod: Brightness,
        signal: 'caps',
        widget: Label({
            vpack: 'center',
            label: 'Caps Lock',
        }),
    },
});

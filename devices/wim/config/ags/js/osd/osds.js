import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';

import { Label } from 'resource:///com/github/Aylur/ags/widget.js';
import OSD from './ctor.js';

import Brightness from '../../services/brightness.js';
import { SpeakerIcon } from '../misc/audio-icons.js';
import { MicIcon } from '../misc/audio-icons.js';

const AUDIO_MAX = 1.5;

const ShowSpeaker = Variable(true);

globalThis.showSpeaker = () => {
    ShowSpeaker.value = !ShowSpeaker.value;
};

/**
 * @typedef {import('types/widgets/stack').default} Stack
 * @typedef {import('types/widgets/progressbar').default} ProgressBar
 */


/** @param {Stack} stack */
export const SpeakerOSD = (stack) => OSD({
    stack,
    icon: { icon: SpeakerIcon.bind() },
    info: {
        mod: ShowSpeaker,

        /** @param {ProgressBar} self */
        logic: (self) => {
            if (!Audio.speaker) {
                return;
            }

            self.value = Audio.speaker ?
                Audio.speaker.volume / AUDIO_MAX :
                0;

            self.sensitive = !Audio.speaker?.stream.is_muted;
        },
    },
});

/** @param {Stack} stack */
export const ScreenBrightnessOSD = (stack) => OSD({
    stack,
    icon: { icon: Brightness.bind('screenIcon') },
    info: {
        mod: Brightness,
        signal: 'screen',

        /** @param {ProgressBar} self */
        logic: (self) => {
            self.value = Brightness.screen;
        },
    },
});

/** @param {Stack} stack */
export const KbdBrightnessOSD = (stack) => OSD({
    stack,
    icon: 'keyboard-brightness-symbolic',
    info: {
        mod: Brightness,
        signal: 'kbd',

        /** @param {ProgressBar} self */
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

/** @param {Stack} stack */
export const MicOSD = (stack) => OSD({
    stack,
    icon: { icon: MicIcon.bind() },
    info: {
        mod: Audio,
        signal: 'microphone-changed',

        /** @param {ProgressBar} self */
        logic: (self) => {
            if (!Audio.microphone) {
                return;
            }

            self.value = Audio.microphone ? Audio.microphone.volume : 0;
            self.sensitive = !Audio.microphone?.stream.is_muted;
        },
    },
});

/** @param {Stack} stack */
export const CapsLockOSD = (stack) => OSD({
    stack,
    icon: { icon: Brightness.bind('capsIcon') },
    info: {
        mod: Brightness,
        signal: 'caps',
        widget: Label({
            vpack: 'center',
            label: 'Caps Lock',
        }),
    },
});

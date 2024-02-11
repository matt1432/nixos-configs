const Audio = await Service.import('audio');

const speakerIcons = {
    101: 'audio-volume-overamplified-symbolic',
    67: 'audio-volume-high-symbolic',
    34: 'audio-volume-medium-symbolic',
    1: 'audio-volume-low-symbolic',
    0: 'audio-volume-muted-symbolic',
};

const micIcons = {
    67: 'audio-input-microphone-high-symbolic',
    34: 'audio-input-microphone-medium-symbolic',
    1: 'audio-input-microphone-low-symbolic',
    0: 'audio-input-microphone-muted-symbolic',
};


export const SpeakerIcon = Variable('');
Audio.connect('speaker-changed', () => {
    if (!Audio.speaker) {
        return;
    }

    if (Audio.speaker.stream?.is_muted) {
        SpeakerIcon.setValue(speakerIcons[0]);
    }
    else {
        const vol = Audio.speaker.volume * 100;

        for (const threshold of [-1, 0, 33, 66, 100]) {
            if (vol > threshold + 1) {
                SpeakerIcon.setValue(speakerIcons[threshold + 1]);
            }
        }
    }
});

export const MicIcon = Variable('');
Audio.connect('microphone-changed', () => {
    if (!Audio.microphone) {
        return;
    }

    if (Audio.microphone.stream?.is_muted) {
        MicIcon.setValue(micIcons[0]);
    }
    else {
        const vol = Audio.microphone.volume * 100;

        for (const threshold of [-1, 0, 33, 66]) {
            if (vol > threshold + 1) {
                MicIcon.setValue(micIcons[threshold + 1]);
            }
        }
    }
});

import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';

import { Label, Box, EventBox, Icon, Revealer } from 'resource:///com/github/Aylur/ags/widget.js';

import { SpeakerIcon } from '../../misc/audio-icons.js';
import Separator from '../../misc/separator.js';


const SpeakerIndicator = (props) => Icon({
    ...props,
    binds: [['icon', SpeakerIcon, 'value']],
});

const SpeakerPercentLabel = (props) => Label({
    ...props,
    connections: [[Audio, (label) => {
        if (Audio.speaker) {
            label.label = `${Math.round(Audio.speaker.volume * 100)}%`;
        }
    }, 'speaker-changed']],
});

const SPACING = 5;

export default () => {
    const rev = Revealer({
        transition: 'slide_right',
        child: Box({
            children: [
                Separator(SPACING),
                SpeakerPercentLabel(),
            ],
        }),
    });

    const widget = EventBox({
        onHover: () => {
            rev.revealChild = true;
        },
        onHoverLost: () => {
            rev.revealChild = false;
        },
        child: Box({
            className: 'audio',
            children: [
                SpeakerIndicator(),

                rev,
            ],
        }),
    });

    widget.rev = rev;

    return widget;
};

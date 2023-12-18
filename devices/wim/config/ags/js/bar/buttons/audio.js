import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';

import { Label, Box, EventBox, Icon, Revealer } from 'resource:///com/github/Aylur/ags/widget.js';

import { SpeakerIcon } from '../../misc/audio-icons.js';
import Separator from '../../misc/separator.js';

const SPACING = 5;


export default () => {
    const icon = Icon({
        icon: SpeakerIcon.bind(),
    });

    const hoverRevLabel = Revealer({
        transition: 'slide_right',

        child: Box({

            children: [
                Separator(SPACING),

                Label().hook(Audio, (self) => {
                    if (Audio.speaker?.volume) {
                        self.label =
                            `${Math.round(Audio.speaker?.volume * 100)}%`;
                    }
                }, 'speaker-changed'),
            ],
        }),
    });

    const widget = EventBox({
        on_hover: () => {
            hoverRevLabel.reveal_child = true;
        },
        on_hover_lost: () => {
            hoverRevLabel.reveal_child = false;
        },

        child: Box({
            class_name: 'audio',

            children: [
                icon,
                hoverRevLabel,
            ],
        }),
    });

    return widget;
};

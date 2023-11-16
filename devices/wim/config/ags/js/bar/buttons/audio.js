import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import { Label, Box, Icon } from 'resource:///com/github/Aylur/ags/widget.js';
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

import { SpeakerIcon } from '../../misc/audio-icons.js';
import Separator from '../../misc/separator.js';
import EventBox  from '../../misc/cursorbox.js';


const SpeakerIndicator = props => Icon({
    ...props,
    binds: [['icon', SpeakerIcon, 'value']],
});

const SpeakerPercentLabel = props => Label({
    ...props,
    connections: [[Audio, label => {
        if (Audio.speaker)
            label.label = Math.round(Audio.speaker.volume * 100) + '%';
    }, 'speaker-changed']],
});

export default () => EventBox({
    onPrimaryClickRelease: () => execAsync(['pavucontrol']).catch(print),
    className: 'toggle-off',
    child: Box({
        className: 'audio',
        children: [
            SpeakerIndicator(),
            Separator(5),
            SpeakerPercentLabel(),
        ],
    }),
});

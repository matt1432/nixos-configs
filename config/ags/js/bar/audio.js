const { Audio } = ags.Service;
const { Label, Box, Icon, Stack, Button, Slider } = ags.Widget;
import { Separator, EventBox } from '../common.js';

const items = {
  101: 'audio-volume-overamplified-symbolic',
  67: 'audio-volume-high-symbolic',
  34: 'audio-volume-medium-symbolic',
  1: 'audio-volume-low-symbolic',
  0: 'audio-volume-muted-symbolic',
};

const SpeakerIndicator = props => Icon({
  ...props,
  icon: '',
  connections: [[Audio, icon => {
    if (!Audio.speaker)
      return;

    if (Audio.speaker.isMuted)
      return icon.icon = items[0];

    const vol = Audio.speaker.volume * 100;
    for (const threshold of [100, 66, 33, 0, -1]) {
      if (vol > threshold + 1)
        return icon.icon = items[threshold + 1];
    }
  }, 'speaker-changed']],
});

const SpeakerPercentLabel = props => Label({
  ...props,
  connections: [[Audio, label => {
    if (!Audio.speaker)
      return;

    label.label = `${Math.floor(Audio.speaker.volume * 100)}%`;
  }, 'speaker-changed']],
});

const AudioModule = () => EventBox({
  onPrimaryClickRelease: 'pavucontrol',
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

export const AudioIndicator = AudioModule();

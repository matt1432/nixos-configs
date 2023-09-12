const { Audio } = ags.Service;
const { Label, Box, Icon, Stack, Button, Slider } = ags.Widget;

import { Separator } from '../misc/separator.js';
import { EventBox } from '../misc/cursorbox.js';

const items = {
  101: 'audio-volume-overamplified-symbolic',
  67: 'audio-volume-high-symbolic',
  34: 'audio-volume-medium-symbolic',
  1: 'audio-volume-low-symbolic',
  0: 'audio-volume-muted-symbolic',
};

const SpeakerIndicator = params => Icon({
  ...params,
  icon: '',
  connections: [[Audio, icon => {
    if (Audio.speaker) {
      if (Audio.speaker.isMuted) {
        icon.icon = items[0];
      }
      else {
        const vol = Audio.speaker.volume * 100;
        for (const threshold of [-1, 0, 33, 66, 100]) {
          if (vol > threshold + 1) {
            icon.icon = items[threshold + 1];
          }
        }
      }
    }
  }, 'speaker-changed']],
});

const SpeakerPercentLabel = params => Label({
  ...params,
  connections: [[Audio, label => {
    if (!Audio.speaker)
      return;

    let vol = Math.floor(Audio.speaker.volume * 100);

    if (vol == 0) {
      label.label = vol + '%';
    }
    else {
      label.label = vol + 1 + '%';
    }
  }, 'speaker-changed']],
});

export const AudioIndicator = EventBox({
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

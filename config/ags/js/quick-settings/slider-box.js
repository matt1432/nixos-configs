const { Box, Slider, Label, Icon } = ags.Widget;
const { Audio } = ags.Service;
const { exec } = ags.Utils;

const items = {
  101: 'audio-volume-overamplified-symbolic',
  67: 'audio-volume-high-symbolic',
  34: 'audio-volume-medium-symbolic',
  1: 'audio-volume-low-symbolic',
  0: 'audio-volume-muted-symbolic',
};

export const SliderBox = Box({
  className: 'slider-box',
  vertical: true,
  halign: 'center',
  children: [

    Box({
      className: 'slider',
      valign: 'start',
      halign: 'center',
      children: [
        Icon({
          size: 26,
          className: 'slider-label',
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
        }),

        Slider({
          value: `${exec('bash -c "$EWW_PATH/volume.sh vol"')}`,
          onChange: 'bash -c "$EWW_PATH/volume.sh set {}"',
          min: 0,
          max: 100,
          draw_value: false,
        }),
      ],
    }),

    Box({
      className: 'slider',
      valign: 'start',
      halign: 'center',
      children: [
        Icon({
          className: 'slider-label',
          icon: 'display-brightness-symbolic',
        }),

        Slider({
          value: `${exec('brightnessctl get') / 2.55}`,
          onChange: "brightnessctl set {}%",
          min: 0,
          max: 100,
          draw_value: false,
        }),
      ],
    }),

  ],
});

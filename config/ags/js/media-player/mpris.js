const { execAsync, lookUpIcon } = ags.Utils;
const { Mpris } = ags.Service;
const { Button, Icon, Label, Stack, Slider, CenterBox } = ags.Widget;
const { Gdk } = imports.gi;
const display = Gdk.Display.get_default();

import { EventBox } from '../misc/cursorbox.js';

const icons = {
  mpris: {
    fallback: 'audio-x-generic-symbolic',
    shuffle: {
      enabled: '󰒝',
      disabled: '󰒞',
    },
    loop: {
      none: '󰑗',
      track: '󰑘',
      playlist: '󰑖',
    },
    playing: ' ',
    paused: ' ',
    stopped: ' ',
    prev: '󰒮',
    next: '󰒭',
  },
}

export const CoverArt = (player, params) => CenterBox({
  ...params,
  className: 'player',
  vertical: true,
  properties: [['bgStyle', '']],
  connections: [
    [player, box => {
      execAsync(['bash', '-c', `[[ -f "${player.coverPath}" ]] && coloryou "${player.coverPath}"`])
      .then(out => {
        if (!Mpris.players.find(p => player === p))
          return;

        player.colors.value = JSON.parse(out);

        box._bgStyle = `background: radial-gradient(circle,
                                    rgba(0, 0, 0, 0.4) 30%,
                                    ${player.colors.value.imageAccent}),
                                    url("${player.coverPath}");
                        background-size: cover;
                        background-position: center;`;
        if (!box.get_parent()._dragging)
          box.setStyle(box._bgStyle);
      }).catch(err => { if (err !== "") print(err) });
    }],
  ],
});

export const TitleLabel = (player, params) => Label({
  ...params,
  xalign: 0,
  maxWidthChars: 40,
  truncate: 'end',
  justification: 'left',
  className: 'title',
  binds: [['label', player, 'trackTitle']],
});

export const ArtistLabel = (player, params) => Label({
  ...params,
  xalign: 0,
  maxWidthChars: 40,
  truncate: 'end',
  justification: 'left',
  className: 'artist',
  connections: [[player, label => {
    label.label = player.trackArtists.join(', ') || '';
  }]],
});

export const PlayerIcon = (player, { symbolic = true, ...params } = {}) => Icon({
  ...params,
  className: 'player-icon',
  size: 32,
  tooltipText: player.identity || '',
  connections: [[player, icon => {
    const name = `${player.entry}${symbolic ? '-symbolic' : ''}`;
    lookUpIcon(name) ? icon.icon = name
                     : icon.icon = icons.mpris.fallback;
  }]],
});

export const PositionSlider = (player, params) => EventBox({
  child: Slider({
    ...params,
    className: 'position-slider',
    hexpand: true,
    drawValue: false,
    onChange: ({ value }) => {
      player.position = player.length * value;
    },
    properties: [
      ['update', slider => {
        if (slider.dragging) {
          slider.get_parent().window.set_cursor(Gdk.Cursor.new_from_name(display, 'grabbing'));
        }
        else {
          if (slider.get_parent() && slider.get_parent().window) {
            slider.get_parent().window.set_cursor(Gdk.Cursor.new_from_name(display, 'pointer'));
          }

          slider.sensitive = player.length > 0;
          if (player.length > 0) {
            slider.value = player.position / player.length;
          }
        }
      }],
    ],
    connections: [
      [player, s => s._update(s), 'position'],
      [1000, s => s._update(s)],
      [player.colors, s => {
        if (player.colors.value)
          s.setCss(`highlight { background-color: ${player.colors.value.buttonAccent}; }
                    slider { background-color: ${player.colors.value.buttonAccent}; }
                    slider:hover { background-color: ${player.colors.value.hoverAccent}; }
                    trough { background-color: ${player.colors.value.buttonAccent}; }`);
      }],
    ],
  }),
});

function lengthStr(length) {
  const min = Math.floor(length / 60);
  const sec0 = Math.floor(length % 60) < 10 ? '0' : '';
  const sec = Math.floor(length % 60);
  return `${min}:${sec0}${sec}`;
}

export const PositionLabel = player => Label({
  properties: [['update', label => {
    player.length > 0 ? label.label = lengthStr(player.position)
                      : label.visible = !!player;
  }]],
  connections: [
    [player, l => l._update(l), 'position'],
    [1000, l => l._update(l)],
  ],
});

export const LengthLabel = player => Label({
  connections: [[player, label => {
    player.length > 0 ? label.label = lengthStr(player.length)
                      : label.visible = !!player;
  }]],
});

export const Slash = player => Label({
  label: '/',
  connections: [[player, label => {
    label.visible = player.length > 0;
  }]],
});

// TODO: use label instead of stack to fix UI issues
const PlayerButton = ({ player, items, onClick, prop }) => Button({
  child: Stack({ items }),
  onPrimaryClickRelease: () => player[onClick](),
  properties: [['hovered', false]],
  onHover: box => {
    box._hovered = true;
    if (! box.child.sensitive || ! box.sensitive) {
      box.window.set_cursor(Gdk.Cursor.new_from_name(display, 'not-allowed'));
    }
    else {
      box.window.set_cursor(Gdk.Cursor.new_from_name(display, 'pointer'));
    }

    if (prop == 'playBackStatus') {
      items.forEach(item => {
        item[1].setStyle(`background-color: ${player.colors.value.hoverAccent};
                          color: ${player.colors.value.buttonText};
                          min-height: 40px; min-width: 36px;
                          margin-bottom: 1px; margin-right: 1px;`);
      });
    }
  },
  onHoverLost: box => {
    box._hovered = false;
    box.window.set_cursor(null);
    if (prop == 'playBackStatus') {
      items.forEach(item => {
        item[1].setStyle(`background-color: ${player.colors.value.buttonAccent};
                          color: ${player.colors.value.buttonText};
                          min-height: 42px; min-width: 38px;`);
      });
    }
  },
  connections: [
    [player, button => {
      button.child.shown = `${player[prop]}`;
    }],

    [player.colors, button => {
      if (!Mpris.players.find(p => player === p))
          return;

      if (player.colors.value) {
        if (prop == 'playBackStatus') {
          if (button._hovered) {
            items.forEach(item => {
              item[1].setStyle(`background-color: ${player.colors.value.hoverAccent};
                                color: ${player.colors.value.buttonText};
                                min-height: 40px; min-width: 36px;
                                margin-bottom: 1px; margin-right: 1px;`);
            });
          }
          else {
            items.forEach(item => {
              item[1].setStyle(`background-color: ${player.colors.value.buttonAccent};
                                color: ${player.colors.value.buttonText};
                                min-height: 42px; min-width: 38px;`);
            });
          }
        }
        else {
          button.setCss(`* { color: ${player.colors.value.buttonAccent}; }
                         *:hover { color: ${player.colors.value.hoverAccent}; }`);
        }
      }
    }],
  ],
});

export const ShuffleButton = player => PlayerButton({
  player,
  items: [
    ['true', Label({
      className: 'shuffle enabled',
      label: icons.mpris.shuffle.enabled,
    })],
    ['false', Label({
      className: 'shuffle disabled',
      label: icons.mpris.shuffle.disabled,
    })],
  ],
  onClick: 'shuffle',
  prop: 'shuffleStatus',
});

export const LoopButton = player => PlayerButton({
  player,
  items: [
    ['None', Label({
      className: 'loop none',
      label: icons.mpris.loop.none,
    })],
    ['Track', Label({
      className: 'loop track',
      label: icons.mpris.loop.track,
    })],
    ['Playlist', Label({
      className: 'loop playlist',
      label: icons.mpris.loop.playlist,
    })],
  ],
  onClick: 'loop',
  prop: 'loopStatus',
});

export const PlayPauseButton = player => PlayerButton({
  player,
  items: [
    ['Playing', Label({
      className: 'pausebutton playing',
      label: icons.mpris.playing,
    })],
    ['Paused', Label({
      className: 'pausebutton paused',
      label: icons.mpris.paused,
    })],
    ['Stopped', Label({
      className: 'pausebutton stopped paused',
      label: icons.mpris.stopped,
    })],
  ],
  onClick: 'playPause',
  prop: 'playBackStatus',
});

export const PreviousButton = player => PlayerButton({
  player,
  items: [
    ['true', Label({
      className: 'previous',
      label: icons.mpris.prev,
    })],
    ['false', Label({
      className: 'previous',
      label: icons.mpris.prev,
    })],
  ],
  onClick: 'previous',
  prop: 'canGoPrev',
});

export const NextButton = player => PlayerButton({
  player,
  items: [
    ['true', Label({
      className: 'next',
      label: icons.mpris.next,
    })],
    ['false', Label({
      className: 'next',
      label: icons.mpris.next,
    })],
  ],
  onClick: 'next',
  prop: 'canGoNext',
});

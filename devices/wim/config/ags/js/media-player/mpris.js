import Mpris from 'resource:///com/github/Aylur/ags/service/mpris.js';
import { Button, Icon, Label, Stack, Slider, CenterBox, Box } from 'resource:///com/github/Aylur/ags/widget.js';
import { execAsync, lookUpIcon, readFileAsync } from 'resource:///com/github/Aylur/ags/utils.js';

import Gdk from 'gi://Gdk';
const display = Gdk.Display.get_default();

import Separator from '../misc/separator.js';
import EventBox  from '../misc/cursorbox.js';

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
};


export const CoverArt = (player, props) => CenterBox({
    ...props,
    vertical: true,
    properties: [['bgStyle', '']],
    connections: [[player, self => {
        // Don't show players that don't have covers
        readFileAsync(player.coverPath).catch(() => {
            if (!player.colors.value && !player.trackCoverUrl)
                player.colors.value = 'delete';
        });

        execAsync(['bash', '-c', `[[ -f "${player.coverPath}" ]] &&
                  coloryou "${player.coverPath}" | grep -v Warning`])
            .then(out => {
                if (!Mpris.players.find(p => player === p))
                    return;

                player.colors.value = JSON.parse(out);

                self._bgStyle = `background: radial-gradient(circle,
                                             rgba(0, 0, 0, 0.4) 30%,
                                             ${player.colors.value.imageAccent}),
                                             url("${player.coverPath}");
                                 background-size: cover;
                                 background-position: center;`;

                if (!self.get_parent()._dragging)
                    self.setStyle(self._bgStyle);
            }).catch(err => {
                if (err !== '')
                    print(err);
            });
    }]],
});

export const TitleLabel = (player, props) => Label({
    ...props,
    xalign: 0,
    maxWidthChars: 40,
    truncate: 'end',
    justification: 'left',
    className: 'title',
    binds: [['label', player, 'track-title']],
});

export const ArtistLabel = (player, props) => Label({
    ...props,
    xalign: 0,
    maxWidthChars: 40,
    truncate: 'end',
    justification: 'left',
    className: 'artist',
    binds: [['label', player, 'track-artists', a => a.join(', ') || '']],
});

export const PlayerIcon = (player, { symbolic = true, ...props } = {}) => {
    const MainIcon = Icon({
        ...props,
        className: 'player-icon',
        size: 32,
        tooltipText: player.identity || '',
        connections: [[player, self => {
            const name = `${player.entry}${symbolic ? '-symbolic' : ''}`;
            lookUpIcon(name) ? self.icon = name
                : self.icon = icons.mpris.fallback;
        }]],
    });

    const widget = Box({});
    var overlay;
    const interval = setInterval(() => {
        if (player.colors.value === 'delete') {
            interval.destroy();
        }
        else if (player.colors.value && player.trackCoverUrl) {
            overlay = widget.get_parent().get_parent().get_parent();
            updateIcons();
            Mpris.connect('changed', updateIcons);
            interval.destroy();
        }
    }, 100);
    const updateIcons = () => {
        const overlays = overlay.list();

        const player = overlays.find(overlay => {
            return overlay === widget.get_parent().get_parent();
        });

        const index = overlays.indexOf(player);

        const children = [];
        for (let i = 0; i < overlays.length; ++i) {
            if (i === index) {
                children.push(MainIcon);
                children.push(Separator(2));
            }
            else {
                children.push(Box({ className: 'position-indicator' }));
                children.push(Separator(2));
            }
        }
        widget.children = children;
    };
    return widget;
};

// FIXME: get the cursors right or just don't display when disabled
export const PositionSlider = (player, props) => EventBox({
    child: Slider({
        ...props,
        className: 'position-slider',
        hexpand: true,
        drawValue: false,
        onChange: ({ value }) => {
            player.position = player.length * value;
        },
        properties: [['update', slider => {
            if (slider.dragging) {
                slider.get_parent().window.set_cursor(Gdk.Cursor
                    .new_from_name(display, 'grabbing'));
            }
            else {
                if (slider.get_parent() && slider.get_parent().window) {
                    slider.get_parent().window.set_cursor(Gdk.Cursor
                        .new_from_name(display, 'pointer'));
                }

                slider.sensitive = player.length > 0;
                if (player.length > 0)
                    slider.value = player.position / player.length;
            }
        }]],
        connections: [
            [player, s => s._update(s), 'position'],
            [1000, s => s._update(s)],
            [player.colors, s => {
                const c = player.colors.value;
                if (c && c != 'delete') {
                    s.setCss(`highlight { background-color: ${c.buttonAccent}; }
                              slider { background-color: ${c.buttonAccent}; }
                              slider:hover { background-color: ${c.hoverAccent}; }
                              trough { background-color: ${c.buttonText}; }`);
                }
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
    properties: [['update', self => {
        player.length > 0 ? self.label = lengthStr(player.position)
            : self.visible = !!player;
    }]],
    connections: [
        [player, l => l._update(l), 'position'],
        [1000, l => l._update(l)],
    ],
});

export const LengthLabel = player => Label({
    connections: [[player, self => {
        player.length > 0 ? self.label = lengthStr(player.length)
            : self.visible = !!player;
    }]],
});

export const Slash = player => Label({
    label: '/',
    connections: [[player, self => {
        self.visible = player.length > 0;
    }]],
});

// TODO: use label instead of stack to fix UI issues
const PlayerButton = ({ player, items, onClick, prop }) => Button({
    child: Stack({ items }),
    onPrimaryClickRelease: () => player[onClick](),
    properties: [['hovered', false]],
    onHover: self => {
        self._hovered = true;
        if (! self.child.sensitive || ! self.sensitive)
            self.window.set_cursor(Gdk.Cursor.new_from_name(display, 'not-allowed'));

        else
            self.window.set_cursor(Gdk.Cursor.new_from_name(display, 'pointer'));


        if (prop == 'playBackStatus') {
            items.forEach(item => {
                item[1].setStyle(`background-color: ${player.colors.value.hoverAccent};
                                  color: ${player.colors.value.buttonText};
                                  min-height: 40px; min-width: 36px;
                                  margin-bottom: 1px; margin-right: 1px;`);
            });
        }
    },
    onHoverLost: self => {
        self._hovered = false;
        self.window.set_cursor(null);
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

            if (player.colors.value && player.colors.value != 'delete') {
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

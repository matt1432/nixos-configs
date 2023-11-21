import Mpris from 'resource:///com/github/Aylur/ags/service/mpris.js';

import { Button, Icon, Label, Stack, Slider, CenterBox, Box } from 'resource:///com/github/Aylur/ags/widget.js';
import { execAsync, lookUpIcon, readFileAsync } from 'resource:///com/github/Aylur/ags/utils.js';

import Separator from '../misc/separator.js';
import EventBox from '../misc/cursorbox.js';

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

    setup: (self) => {
        // Give temp cover art
        readFileAsync(player.coverPath).catch(() => {
            if (!player.colors.value && !player.trackCoverUrl) {
                player.colors.value = {
                    imageAccent: '#6b4fa2',
                    buttonAccent: '#ecdcff',
                    buttonText: '#25005a',
                    hoverAccent: '#d4baff',
                };

                self._bgStyle = `
                    background: radial-gradient(circle,
                                rgba(0, 0, 0, 0.4) 30%,
                                ${player.colors.value.imageAccent}),
                                rgb(0, 0, 0);
                    background-size: cover;
                    background-position: center;
                `;
                self.setCss(self._bgStyle);
            }
        });
    },

    connections: [[player, (self) => {
        execAsync(['bash', '-c', `[[ -f "${player.coverPath}" ]] &&
                  coloryou "${player.coverPath}" | grep -v Warning`])
            .then((out) => {
                if (!Mpris.players.find((p) => player === p)) {
                    return;
                }

                player.colors.value = JSON.parse(out);

                self._bgStyle = `
                    background: radial-gradient(circle,
                                rgba(0, 0, 0, 0.4) 30%,
                                ${player.colors.value.imageAccent}),
                                url("${player.coverPath}");
                    background-size: cover;
                    background-position: center;
                `;

                if (!self.get_parent()._dragging) {
                    self.setCss(self._bgStyle);
                }
            }).catch((err) => {
                if (err !== '') {
                    print(err);
                }
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

    binds: [['label', player, 'track-artists', (a) => a.join(', ') || '']],
});

export const PlayerIcon = (player, { symbolic = true, ...props } = {}) => {
    // Get player's icon
    const MainIcon = Icon({
        ...props,
        className: 'player-icon',
        size: 32,
        tooltipText: player.identity || '',

        connections: [[player, (self) => {
            const name = `${player.entry}${symbolic ? '-symbolic' : ''}`;

            lookUpIcon(name) ?
                self.icon = name :
                self.icon = icons.mpris.fallback;
        }]],
    });

    // Multiple player indicators
    return Box({
        properties: [['overlay']],
        connections: [[Mpris, (self) => {
            if (!self._overlay) {
                self._overlay = self.get_parent().get_parent().get_parent();
            }

            const overlays = self._overlay.list();

            const playerWidget = overlays.find((overlay) => {
                return overlay === self.get_parent().get_parent();
            });

            const index = overlays.indexOf(playerWidget);

            const children = [];

            for (let i = 0; i < overlays.length; ++i) {
                if (i === index) {
                    children.push(Separator(2));
                    children.push(MainIcon);
                }
                else {
                    children.push(Separator(2));
                    // TODO: make this clickable to switch
                    children.push(Box({ className: 'position-indicator' }));
                }
            }
            self.children = children.reverse();
        }]],
    });
};

export const PositionSlider = (player, props) => Slider({
    ...props,
    className: 'position-slider',
    cursor: 'pointer',
    vpack: 'center',
    hexpand: true,
    drawValue: false,

    onChange: ({ value }) => {
        player.position = player.length * value;
    },

    properties: [['update', (slider) => {
        if (!slider.dragging) {
            slider.visible = player.length > 0;
            if (player.length > 0) {
                slider.value = player.position / player.length;
            }
        }
    }]],

    connections: [
        [1000, (s) => s._update(s)],
        [player, (s) => s._update(s), 'position'],
        [player.colors, (s) => {
            if (player.colors.value) {
                const c = player.colors.value;

                s.setCss(`
                    highlight    { background-color: ${c.buttonAccent}; }
                    slider       { background-color: ${c.buttonAccent}; }
                    slider:hover { background-color: ${c.hoverAccent}; }
                    trough       { background-color: ${c.buttonText}; }
                `);
            }
        }],

        ['button-press-event', (s) => {
            s.cursor = 'grabbing';
        }],
        ['button-release-event', (s) => {
            s.cursor = 'pointer';
        }],
    ],
});

const PlayerButton = ({ player, items, onClick, prop }) => EventBox({
    child: Button({
        properties: [['hovered', false]],
        child: Stack({ items }),

        onPrimaryClickRelease: () => player[onClick](),

        onHover: (self) => {
            self._hovered = true;

            if (prop === 'playBackStatus') {
                items.forEach((item) => {
                    item[1].setCss(`
                    background-color: ${player.colors.value.hoverAccent};
                    color: ${player.colors.value.buttonText};
                    min-height: 40px;
                    min-width: 36px;
                    margin-bottom: 1px;
                    margin-right: 1px;
                `);
                });
            }
        },

        onHoverLost: (self) => {
            self._hovered = false;
            if (prop === 'playBackStatus') {
                items.forEach((item) => {
                    item[1].setCss(`
                    background-color: ${player.colors.value.buttonAccent};
                    color: ${player.colors.value.buttonText};
                    min-height: 42px;
                    min-width: 38px;
                `);
                });
            }
        },

        connections: [
            [player, (button) => {
                button.child.shown = `${player[prop]}`;
            }],

            [player.colors, (button) => {
                if (!Mpris.players.find((p) => player === p)) {
                    return;
                }

                if (player.colors.value) {
                    const c = player.colors.value;

                    if (prop === 'playBackStatus') {
                        if (button._hovered) {
                            items.forEach((item) => {
                                item[1].setCss(`
                                background-color: ${c.hoverAccent};
                                color: ${c.buttonText};
                                min-height: 40px;
                                min-width: 36px;
                                margin-bottom: 1px;
                                margin-right: 1px;
                            `);
                            });
                        }
                        else {
                            items.forEach((item) => {
                                item[1].setCss(`
                                background-color: ${c.buttonAccent};
                                color: ${c.buttonText};
                                min-height: 42px;
                                min-width: 38px;`);
                            });
                        }
                    }
                    else {
                        button.setCss(`
                        *       { color: ${c.buttonAccent}; }
                        *:hover { color: ${c.hoverAccent}; }
                    `);
                    }
                }
            }],
        ],
    }),
});

export const ShuffleButton = (player) => PlayerButton({
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

export const LoopButton = (player) => PlayerButton({
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

export const PlayPauseButton = (player) => PlayerButton({
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

export const PreviousButton = (player) => PlayerButton({
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

export const NextButton = (player) => PlayerButton({
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

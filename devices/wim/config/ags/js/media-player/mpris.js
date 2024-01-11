import Mpris from 'resource:///com/github/Aylur/ags/service/mpris.js';

import { Button, Icon, Label, Stack, Slider, CenterBox, Box } from 'resource:///com/github/Aylur/ags/widget.js';
import { execAsync, lookUpIcon, readFileAsync } from 'resource:///com/github/Aylur/ags/utils.js';

import Separator from '../misc/separator.js';
import CursorBox from '../misc/cursorbox.js';

/**
 * @typedef {import('types/service/mpris').MprisPlayer} Player
 * @typedef {import('types/variable').Variable} Variable
 * @typedef {import('types/widgets/overlay').default} Overlay
 */

const ICON_SIZE = 32;

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


/**
 * @param {Player} player
 * @param {Variable} colors
 * @param {import('types/widgets/centerbox').CenterBoxProps=} props
 */
export const CoverArt = (player, colors, props) => CenterBox({
    ...props,
    // @ts-expect-error
    vertical: true,

    attribute: {
        bgStyle: '',
        player,
    },

    setup: (self) => {
        // Give temp cover art
        readFileAsync(player.cover_path).catch(() => {
            if (!colors.value && !player.track_cover_url) {
                colors.value = {
                    imageAccent: '#6b4fa2',
                    buttonAccent: '#ecdcff',
                    buttonText: '#25005a',
                    hoverAccent: '#d4baff',
                };

                self.attribute.bgStyle = `
                    background: radial-gradient(circle,
                                rgba(0, 0, 0, 0.4) 30%,
                                ${colors.value.imageAccent}),
                                rgb(0, 0, 0);
                    background-size: cover;
                    background-position: center;
                `;
                self.setCss(self.attribute.bgStyle);
            }
        });

        self.hook(player, () => {
            execAsync(['bash', '-c', `[[ -f "${player.cover_path}" ]] &&
                  coloryou "${player.cover_path}" | grep -v Warning`])
                .then((out) => {
                    if (!Mpris.players.find((p) => player === p)) {
                        return;
                    }

                    colors.value = JSON.parse(out);

                    self.attribute.bgStyle = `
                        background: radial-gradient(circle,
                                    rgba(0, 0, 0, 0.4) 30%,
                                    ${colors.value.imageAccent}),
                                    url("${player.cover_path}");
                        background-size: cover;
                        background-position: center;
                    `;

                    // @ts-expect-error
                    if (!self?.get_parent()?.attribute.dragging) {
                        self.setCss(self.attribute.bgStyle);
                    }
                }).catch((err) => {
                    if (err !== '') {
                        print(err);
                    }
                });
        });
    },
});

/** @param {Player} player */
export const TitleLabel = (player) => Label({
    xalign: 0,
    max_width_chars: 40,
    truncate: 'end',
    justification: 'left',
    class_name: 'title',
    label: player.bind('track_title'),
});

/** @param {Player} player */
export const ArtistLabel = (player) => Label({
    xalign: 0,
    max_width_chars: 40,
    truncate: 'end',
    justification: 'left',
    class_name: 'artist',
    label: player.bind('track_artists')
        .transform((a) => a.join(', ') || ''),
});


/**
 * @param {Player} player
 * @param {Overlay} overlay
 */
export const PlayerIcon = (player, overlay) => {
    /**
     * @param {Player} p
     * @param {Overlay=} widget
     * @param {Overlay=} over
     */
    const playerIcon = (p, widget, over) => CursorBox({
        tooltip_text: p.identity || '',

        on_primary_click_release: () => {
            widget?.attribute.moveToTop(over);
        },

        child: Icon({
            class_name: widget ? 'position-indicator' : 'player-icon',
            size: widget ? 0 : ICON_SIZE,

            setup: (self) => {
                self.hook(p, () => {
                    self.icon = lookUpIcon(p.entry) ?
                        p.entry :
                        icons.mpris.fallback;
                });
            },
        }),
    });

    return Box().hook(Mpris, (self) => {
        const thisIndex = overlay.attribute.list()
            .indexOf(self?.get_parent()?.get_parent());

        self.children = Array.from(overlay.attribute.list())
            .map((over, i) => {
                self.children.push(Separator(2));

                return i === thisIndex ?
                    playerIcon(player) :
                    playerIcon(over.attribute.player, overlay, over);
            })
            .reverse();
    });
};

const { Gdk } = imports.gi;
const display = Gdk.Display.get_default();

/**
 * @param {Player} player
 * @param {Variable} colors
 */
export const PositionSlider = (player, colors) => Slider({
    class_name: 'position-slider',
    vpack: 'center',
    hexpand: true,
    draw_value: false,

    on_change: ({ value }) => {
        player.position = player.length * value;
    },

    setup: (self) => {
        const update = () => {
            if (!self.dragging) {
                self.visible = player.length > 0;
                if (player.length > 0) {
                    self.value = player.position / player.length;
                }
            }
        };

        self
            .poll(1000, () => update())
            .hook(player, () => update(), 'position')
            .hook(colors, () => {
                if (colors.value) {
                    const c = colors.value;

                    self.setCss(`
                        highlight    { background-color: ${c.buttonAccent}; }
                        slider       { background-color: ${c.buttonAccent}; }
                        slider:hover { background-color: ${c.hoverAccent}; }
                        trough       { background-color: ${c.buttonText}; }
                    `);
                }
            })

            // OnClick
            .on('button-press-event', () => {
                self.window.set_cursor(Gdk.Cursor.new_from_name(
                    display,
                    'grabbing',
                ));
            })

            // OnRelease
            .on('button-release-event', () => {
                self.window.set_cursor(Gdk.Cursor.new_from_name(
                    display,
                    'pointer',
                ));
            })

            // OnHover
            .on('enter-notify-event', () => {
                self.window.set_cursor(Gdk.Cursor.new_from_name(
                    display,
                    'pointer',
                ));
                self.toggleClassName('hover', true);
            })

            // OnHoverLost
            .on('leave-notify-event', () => {
                self.window.set_cursor(null);
                self.toggleClassName('hover', false);
            });
    },
});

const PlayerButton = ({
    player,
    colors,
    items,
    onClick,
    prop,
}) => CursorBox({
    child: Button({
        attribute: { hovered: false },
        child: Stack({ items }),

        on_primary_click_release: () => player[onClick](),

        on_hover: (self) => {
            self.attribute.hovered = true;

            if (prop === 'playBackStatus' && colors.value) {
                const c = colors.value;

                Array.from(items).forEach((item) => {
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
        },

        on_hover_lost: (self) => {
            self.attribute.hovered = false;
            if (prop === 'playBackStatus' && colors.value) {
                const c = colors.value;

                Array.from(items).forEach((item) => {
                    item[1].setCss(`
                        background-color: ${c.buttonAccent};
                        color: ${c.buttonText};
                        min-height: 42px;
                        min-width: 38px;
                    `);
                });
            }
        },

        setup: (self) => {
            self
                .hook(player, () => {
                    // @ts-expect-error
                    self.child.shown = `${player[prop]}`;
                })
                .hook(colors, () => {
                    if (!Mpris.players.find((p) => player === p)) {
                        return;
                    }

                    if (colors.value) {
                        const c = colors.value;

                        if (prop === 'playBackStatus') {
                            if (self.attribute.hovered) {
                                Array.from(items).forEach((item) => {
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
                                Array.from(items).forEach((item) => {
                                    item[1].setCss(`
                                        background-color: ${c.buttonAccent};
                                        color: ${c.buttonText};
                                        min-height: 42px;
                                        min-width: 38px;
                                    `);
                                });
                            }
                        }
                        else {
                            self.setCss(`
                                *       { color: ${c.buttonAccent}; }
                                *:hover { color: ${c.hoverAccent}; }
                            `);
                        }
                    }
                });
        },
    }),
});

/**
 * @param {Player} player
 * @param {Variable} colors
 */
export const ShuffleButton = (player, colors) => PlayerButton({
    player,
    colors,
    items: [
        ['true', Label({
            class_name: 'shuffle enabled',
            label: icons.mpris.shuffle.enabled,
        })],
        ['false', Label({
            class_name: 'shuffle disabled',
            label: icons.mpris.shuffle.disabled,
        })],
    ],
    onClick: 'shuffle',
    prop: 'shuffleStatus',
});

/**
 * @param {Player} player
 * @param {Variable} colors
 */
export const LoopButton = (player, colors) => PlayerButton({
    player,
    colors,
    items: [
        ['None', Label({
            class_name: 'loop none',
            label: icons.mpris.loop.none,
        })],
        ['Track', Label({
            class_name: 'loop track',
            label: icons.mpris.loop.track,
        })],
        ['Playlist', Label({
            class_name: 'loop playlist',
            label: icons.mpris.loop.playlist,
        })],
    ],
    onClick: 'loop',
    prop: 'loopStatus',
});

/**
 * @param {Player} player
 * @param {Variable} colors
 */
export const PlayPauseButton = (player, colors) => PlayerButton({
    player,
    colors,
    items: [
        ['Playing', Label({
            class_name: 'pausebutton playing',
            label: icons.mpris.playing,
        })],
        ['Paused', Label({
            class_name: 'pausebutton paused',
            label: icons.mpris.paused,
        })],
        ['Stopped', Label({
            class_name: 'pausebutton stopped paused',
            label: icons.mpris.stopped,
        })],
    ],
    onClick: 'playPause',
    prop: 'playBackStatus',
});

/**
 * @param {Player} player
 * @param {Variable} colors
 */
export const PreviousButton = (player, colors) => PlayerButton({
    player,
    colors,
    items: [
        ['true', Label({
            class_name: 'previous',
            label: icons.mpris.prev,
        })],
        ['false', Label({
            class_name: 'previous',
            label: icons.mpris.prev,
        })],
    ],
    onClick: 'previous',
    prop: 'canGoPrev',
});

/**
 * @param {Player} player
 * @param {Variable} colors
 */
export const NextButton = (player, colors) => PlayerButton({
    player,
    colors,
    items: [
        ['true', Label({
            class_name: 'next',
            label: icons.mpris.next,
        })],
        ['false', Label({
            class_name: 'next',
            label: icons.mpris.next,
        })],
    ],
    onClick: 'next',
    prop: 'canGoNext',
});

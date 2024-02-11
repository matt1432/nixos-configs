const Mpris = await Service.import('mpris');

const { Button, Icon, Label, Stack, Slider, CenterBox, Box } = Widget;
const { execAsync, lookUpIcon, readFileAsync } = Utils;

import Separator from '../misc/separator.ts';
import CursorBox from '../misc/cursorbox.ts';

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

// Types
import { MprisPlayer } from 'types/service/mpris.ts';
import { Variable as Var } from 'types/variable';

import {
    AgsWidget,
    CenterBoxPropsGeneric,
    Colors,
    PlayerBox,
    PlayerButtonType,
    PlayerDrag,
    PlayerOverlay,
} from 'global-types';


export const CoverArt = (
    player: MprisPlayer,
    colors: Var<Colors>,
    props: CenterBoxPropsGeneric,
) => CenterBox({
    ...props,
    vertical: true,

    attribute: {
        bgStyle: '',
        player,
    },

    setup: (self: PlayerBox) => {
        // Give temp cover art
        readFileAsync(player.cover_path).catch(() => {
            if (!colors.value && !player.track_cover_url) {
                colors.setValue({
                    imageAccent: '#6b4fa2',
                    buttonAccent: '#ecdcff',
                    buttonText: '#25005a',
                    hoverAccent: '#d4baff',
                });

                self.attribute.bgStyle = `
                    background: radial-gradient(circle,
                                rgba(0, 0, 0, 0.4) 30%,
                                ${(colors as Var<Colors>).value.imageAccent}),
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

                    colors.setValue(JSON.parse(out));

                    self.attribute.bgStyle = `
                        background: radial-gradient(circle,
                                    rgba(0, 0, 0, 0.4) 30%,
                                    ${colors.value.imageAccent}),
                                    url("${player.cover_path}");
                        background-size: cover;
                        background-position: center;
                    `;

                    if (!(self.get_parent() as PlayerDrag)
                        .attribute.dragging) {
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

export const TitleLabel = (player: MprisPlayer) => Label({
    xalign: 0,
    max_width_chars: 40,
    truncate: 'end',
    justification: 'left',
    class_name: 'title',
    label: player.bind('track_title'),
});

export const ArtistLabel = (player: MprisPlayer) => Label({
    xalign: 0,
    max_width_chars: 40,
    truncate: 'end',
    justification: 'left',
    class_name: 'artist',
    label: player.bind('track_artists')
        .transform((a) => a.join(', ') || ''),
});


export const PlayerIcon = (player: MprisPlayer, overlay: PlayerOverlay) => {
    const playerIcon = (
        p: MprisPlayer,
        widget?: PlayerOverlay,
        playerBox?: PlayerBox,
    ) => CursorBox({
        tooltip_text: p.identity || '',

        on_primary_click_release: () => {
            if (widget && playerBox) {
                widget.attribute.moveToTop(playerBox);
            }
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
        const grandPa = self.get_parent()?.get_parent() as AgsWidget;

        if (!grandPa) {
            return;
        }

        const thisIndex = overlay.overlays
            .indexOf(grandPa);

        self.children = (overlay.overlays as PlayerBox[])
            .map((playerBox, i) => {
                self.children.push(Separator(2));

                return i === thisIndex ?
                    playerIcon(player) :
                    playerIcon(playerBox.attribute.player, overlay, playerBox);
            })
            .reverse();
    });
};

const { Gdk } = imports.gi;
const display = Gdk.Display.get_default();

export const PositionSlider = (
    player: MprisPlayer,
    colors: Var<Colors>,
) => Slider({
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
                if (!display) {
                    return;
                }
                self.window.set_cursor(Gdk.Cursor.new_from_name(
                    display,
                    'grabbing',
                ));
            })

            // OnRelease
            .on('button-release-event', () => {
                if (!display) {
                    return;
                }
                self.window.set_cursor(Gdk.Cursor.new_from_name(
                    display,
                    'pointer',
                ));
            })

            // OnHover
            .on('enter-notify-event', () => {
                if (!display) {
                    return;
                }
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
    children = {},
    onClick,
    prop,
}: PlayerButtonType) => CursorBox({
    child: Button({
        attribute: { hovered: false },
        child: Stack({ children }),

        on_primary_click_release: () => player[onClick](),

        on_hover: (self) => {
            self.attribute.hovered = true;

            if (prop === 'playBackStatus' && colors.value) {
                const c = colors.value;

                Object.values(children).forEach((ch: AgsWidget) => {
                    ch.setCss(`
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

                Object.values(children).forEach((ch: AgsWidget) => {
                    ch.setCss(`
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
                                Object.values(children)
                                    .forEach((ch: AgsWidget) => {
                                        ch.setCss(`
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
                                Object.values(children)
                                    .forEach((ch: AgsWidget) => {
                                        ch.setCss(`
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

export const ShuffleButton = (
    player: MprisPlayer,
    colors: Var<Colors>,
) => PlayerButton({
    player,
    colors,
    children: {
        true: Label({
            class_name: 'shuffle enabled',
            label: icons.mpris.shuffle.enabled,
        }),
        false: Label({
            class_name: 'shuffle disabled',
            label: icons.mpris.shuffle.disabled,
        }),
    },
    onClick: 'shuffle',
    prop: 'shuffleStatus',
});

export const LoopButton = (
    player: MprisPlayer,
    colors: Var<Colors>,
) => PlayerButton({
    player,
    colors,
    children: {
        None: Label({
            class_name: 'loop none',
            label: icons.mpris.loop.none,
        }),
        Track: Label({
            class_name: 'loop track',
            label: icons.mpris.loop.track,
        }),
        Playlist: Label({
            class_name: 'loop playlist',
            label: icons.mpris.loop.playlist,
        }),
    },
    onClick: 'loop',
    prop: 'loopStatus',
});

export const PlayPauseButton = (
    player: MprisPlayer,
    colors: Var<Colors>,
) => PlayerButton({
    player,
    colors,
    children: {
        Playing: Label({
            class_name: 'pausebutton playing',
            label: icons.mpris.playing,
        }),
        Paused: Label({
            class_name: 'pausebutton paused',
            label: icons.mpris.paused,
        }),
        Stopped: Label({
            class_name: 'pausebutton stopped paused',
            label: icons.mpris.stopped,
        }),
    },
    onClick: 'playPause',
    prop: 'playBackStatus',
});

export const PreviousButton = (
    player: MprisPlayer,
    colors: Var<Colors>,
) => PlayerButton({
    player,
    colors,
    children: {
        true: Label({
            class_name: 'previous',
            label: icons.mpris.prev,
        }),
        false: Label({
            class_name: 'previous',
            label: icons.mpris.prev,
        }),
    },
    onClick: 'previous',
    prop: 'canGoPrev',
});

export const NextButton = (
    player: MprisPlayer,
    colors: Var<Colors>,
) => PlayerButton({
    player,
    colors,
    children: {
        true: Label({
            class_name: 'next',
            label: icons.mpris.next,
        }),
        false: Label({
            class_name: 'next',
            label: icons.mpris.next,
        }),
    },
    onClick: 'next',
    prop: 'canGoNext',
});

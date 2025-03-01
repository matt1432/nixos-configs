import { bind, execAsync, idle, type Variable } from 'astal';
import { Gdk, Gtk } from 'astal/gtk3';
import { Box, Button, CenterBoxProps, Icon, Label, Slider, Stack } from 'astal/gtk3/widget';
import { kebabify } from 'astal/binding';

import Mpris from 'gi://AstalMpris';

import Separator from '../misc/separator';

import { PlayerBox, PlayerGesture } from './gesture';

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
        playing: 'media-playback-pause-symbolic',
        paused: 'media-playback-start-symbolic',
        stopped: 'media-playback-stop-symbolic',
        prev: '󰒮',
        next: '󰒭',
    },
};

/* Types */
export interface Colors {
    imageAccent: string
    buttonAccent: string
    buttonText: string
    hoverAccent: string
}


export const CoverArt = (
    player: Mpris.Player,
    colors: Variable<Colors>,
    props: CenterBoxProps,
) => new PlayerBox({
    ...props,
    vertical: true,

    bgStyle: '',
    player,

    setup: (self: PlayerBox) => {
        const setCover = () => {
            execAsync(['bash', '-c', `[[ -f "${player.coverArt}" ]] &&
                  coloryou "${player.coverArt}" | grep -v Warning`])
                .then((out) => {
                    if (!player.coverArt) {
                        return;
                    }

                    colors.set(JSON.parse(out));

                    self.bgStyle = `
                        background: radial-gradient(circle,
                                    rgba(0, 0, 0, 0.4) 30%,
                                    ${colors.get().imageAccent}),
                                    url("${player.coverArt}");
                        background-size: cover;
                        background-position: center;
                    `;

                    if (!(self.get_parent() as PlayerGesture).dragging) {
                        self.css = self.bgStyle;
                    }
                }).catch(() => {
                    colors.set({
                        imageAccent: '#6b4fa2',
                        buttonAccent: '#ecdcff',
                        buttonText: '#25005a',
                        hoverAccent: '#d4baff',
                    });

                    self.bgStyle = `
                        background: radial-gradient(circle,
                                    rgba(0, 0, 0, 0.4) 30%,
                                    ${(colors as Variable<Colors>).get().imageAccent}),
                                    rgb(0, 0, 0);
                        background-size: cover;
                        background-position: center;
                    `;
                    self.css = self.bgStyle;
                });
        };

        player.connect('notify::cover-art', () => setCover());
        idle(() => setCover());
    },
});

export const TitleLabel = (player: Mpris.Player) => new Label({
    xalign: 0,
    max_width_chars: 40,
    truncate: true,
    justify: Gtk.Justification.LEFT,
    className: 'title',
    label: bind(player, 'title'),
});

export const ArtistLabel = (player: Mpris.Player) => new Label({
    xalign: 0,
    max_width_chars: 40,
    truncate: true,
    justify: Gtk.Justification.LEFT,
    className: 'artist',
    label: bind(player, 'artist'),
});


export const PlayerIcon = (player: Mpris.Player, overlay: PlayerGesture) => {
    const playerIcon = (
        p: Mpris.Player,
        widget?: PlayerGesture,
        playerBox?: PlayerBox,
    ) => new Button({
        tooltip_text: p.identity || '',

        onButtonReleaseEvent: () => {
            if (widget && playerBox) {
                widget.moveToTop(playerBox);
            }
        },

        child: new Icon({
            css: `font-size: ${ICON_SIZE}px;`,
            className: widget ? 'position-indicator' : 'player-icon',

            setup: (self) => {
                idle(() => {
                    if (p.entry === null) { return; }

                    self.icon = Icon.lookup_icon(p.entry) ?
                        p.entry :
                        icons.mpris.fallback;
                });
            },
        }),
    });

    return new Box({
        setup(self) {
            const update = () => {
                const grandPa = self.get_parent()?.get_parent();

                if (!grandPa) {
                    return;
                }

                const thisIndex = overlay.overlays.indexOf(grandPa);

                self.children = (overlay.overlays as PlayerBox[])
                    .map((playerBox, i) => {
                        self.children.push(Separator({ size: 2 }));

                        return i === thisIndex ?
                            playerIcon(player) :
                            playerIcon(playerBox.player, overlay, playerBox);
                    })
                    .reverse();
            };

            self.hook(Mpris.get_default(), 'player-added', update);
            self.hook(Mpris.get_default(), 'player-closed', update);

            idle(() => update());
        },
    });
};

const display = Gdk.Display.get_default();

export const PositionSlider = (
    player: Mpris.Player,
    colors: Variable<Colors>,
) => new Slider({
    className: 'position-slider',
    valign: Gtk.Align.CENTER,
    hexpand: true,
    draw_value: false,

    onDragged: ({ value }) => {
        player.position = player.length * value;
    },

    onButtonPressEvent: (self) => {
        if (!display) {
            return;
        }
        self.window.set_cursor(Gdk.Cursor.new_from_name(
            display,
            'grabbing',
        ));
    },

    onButtonReleaseEvent: (self) => {
        if (!display) {
            return;
        }
        self.window.set_cursor(Gdk.Cursor.new_from_name(
            display,
            'pointer',
        ));
    },

    onEnterNotifyEvent: (self) => {
        if (!display) {
            return;
        }
        self.window.set_cursor(Gdk.Cursor.new_from_name(
            display,
            'pointer',
        ));
    },

    onLeaveNotifyEvent: (self) => {
        self.window.set_cursor(null);
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

        const interval = setInterval(() => {
            if (player) {
                update();
            }
            else {
                interval.destroy();
            }
        }, 1000);

        self.hook(colors, () => {
            if (colors.get()) {
                const c = colors.get();

                self.css = `
                    highlight    { background-color: ${c.buttonAccent}; }
                    slider       { background-color: ${c.buttonAccent}; }
                    slider:hover { background-color: ${c.hoverAccent}; }
                    trough       { background-color: ${c.buttonText}; }
                `;
            }
        });

        player.connect('notify::position', () => update());
    },
});

const PlayerButton = ({
    player,
    colors,
    children = [],
    onClick,
    prop,
}: {
    player: Mpris.Player
    colors: Variable<Colors>
    children: Label[] | Icon[]
    onClick: keyof Mpris.Player
    prop: string
}) => {
    let hovered = false;
    const stack = new Stack({ children });

    return new Button({
        cursor: 'pointer',

        child: stack,

        // @ts-expect-error FIXME
        onButtonReleaseEvent: () => player[onClick](),

        onHover: () => {
            hovered = true;

            if (prop === 'playbackStatus' && colors.get()) {
                const c = colors.get();

                children.forEach((ch) => {
                    ch.css = `
                        background-color: ${c.hoverAccent};
                        color: ${c.buttonText};
                        min-height: 40px;
                        min-width: 36px;
                        margin-bottom: 1px;
                        margin-right: 1px;
                    `;
                });
            }
        },

        onHoverLost: () => {
            hovered = false;
            if (prop === 'playbackStatus' && colors.get()) {
                const c = colors.get();

                children.forEach((ch) => {
                    ch.css = `
                        background-color: ${c.buttonAccent};
                        color: ${c.buttonText};
                        min-height: 42px;
                        min-width: 38px;
                    `;
                });
            }
        },

        setup: (self) => {
            // @ts-expect-error FIXME
            if (player[prop] && player[prop] !== false) {
                // @ts-expect-error FIXME
                stack.shown = String(player[prop]);
            }

            player.connect(`notify::${kebabify(prop)}`, () => {
                // @ts-expect-error FIXME
                if (player[prop] !== 0) {
                    // @ts-expect-error FIXME
                    stack.shown = String(player[prop]);
                }
            });

            self.hook(colors, () => {
                if (!Mpris.get_default().get_players().find((p) => player === p)) {
                    return;
                }

                if (colors.get()) {
                    const c = colors.get();

                    if (prop === 'playbackStatus') {
                        if (hovered) {
                            children.forEach((ch) => {
                                ch.css = `
                                    background-color: ${c.hoverAccent};
                                    color: ${c.buttonText};
                                    min-height: 40px;
                                    min-width: 36px;
                                    margin-bottom: 1px;
                                    margin-right: 1px;
                                `;
                            });
                        }
                        else {
                            children.forEach((ch) => {
                                ch.css = `
                                    background-color: ${c.buttonAccent};
                                    color: ${c.buttonText};
                                    min-height: 42px;
                                    min-width: 38px;
                                `;
                            });
                        }
                    }
                    else {
                        self.css = `
                            *       { color: ${c.buttonAccent}; }
                            *:hover { color: ${c.hoverAccent}; }
                        `;
                    }
                }
            });
        },
    });
};

export const ShuffleButton = (
    player: Mpris.Player,
    colors: Variable<Colors>,
) => PlayerButton({
    player,
    colors,
    children: [
        (new Label({
            name: Mpris.Shuffle.ON.toString(),
            className: 'shuffle enabled',
            label: icons.mpris.shuffle.enabled,
        })),
        (new Label({
            name: Mpris.Shuffle.OFF.toString(),
            className: 'shuffle disabled',
            label: icons.mpris.shuffle.disabled,
        })),
    ],
    onClick: 'shuffle',
    prop: 'shuffleStatus',
});

export const LoopButton = (
    player: Mpris.Player,
    colors: Variable<Colors>,
) => PlayerButton({
    player,
    colors,
    children: [
        (new Label({
            name: Mpris.Loop.NONE.toString(),
            className: 'loop none',
            label: icons.mpris.loop.none,
        })),
        (new Label({
            name: Mpris.Loop.TRACK.toString(),
            className: 'loop track',
            label: icons.mpris.loop.track,
        })),
        (new Label({
            name: Mpris.Loop.PLAYLIST.toString(),
            className: 'loop playlist',
            label: icons.mpris.loop.playlist,
        })),
    ],
    onClick: 'loop',
    prop: 'loopStatus',
});

export const PlayPauseButton = (
    player: Mpris.Player,
    colors: Variable<Colors>,
) => PlayerButton({
    player,
    colors,
    children: [
        (new Icon({
            name: Mpris.PlaybackStatus.PLAYING.toString(),
            className: 'pausebutton playing',
            icon: icons.mpris.playing,
        })),
        (new Icon({
            name: Mpris.PlaybackStatus.PAUSED.toString(),
            className: 'pausebutton paused',
            icon: icons.mpris.paused,
        })),
        (new Icon({
            name: Mpris.PlaybackStatus.STOPPED.toString(),
            className: 'pausebutton stopped paused',
            icon: icons.mpris.stopped,
        })),
    ],
    onClick: 'play_pause',
    prop: 'playbackStatus',
});

export const PreviousButton = (
    player: Mpris.Player,
    colors: Variable<Colors>,
) => PlayerButton({
    player,
    colors,
    children: [
        (new Label({
            name: 'true',
            className: 'previous',
            label: icons.mpris.prev,
        })),
        (new Label({
            name: 'false',
            className: 'previous',
            label: icons.mpris.prev,
        })),
    ],
    onClick: 'previous',
    prop: 'canGoPrev',
});

export const NextButton = (
    player: Mpris.Player,
    colors: Variable<Colors>,
) => PlayerButton({
    player,
    colors,
    children: [
        (new Label({
            name: 'true',
            className: 'next',
            label: icons.mpris.next,
        })),
        (new Label({
            name: 'false',
            className: 'next',
            label: icons.mpris.next,
        })),
    ],
    onClick: 'next',
    prop: 'canGoNext',
});

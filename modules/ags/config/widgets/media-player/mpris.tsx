import { Astal, Gdk, Gtk } from 'ags/gtk3';
import { execAsync } from 'ags/process';
import { idle } from 'ags/time';
import Mpris from 'gi://AstalMpris';
import { Accessor, createBinding, Setter } from 'gnim';

import { getCssProvider, setCss } from '../../lib/widgets';
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

export interface Colors {
    imageAccent: string;
    buttonAccent: string;
    buttonText: string;
    hoverAccent: string;
}

const kebabify = (str: string) => {
    return str
        .replace(/([a-z])([A-Z])/g, '$1-$2')
        .replaceAll('_', '-')
        .toLowerCase();
};

export const CoverArt = ({
    player,
    colors,
    setColors,
    props,
}: {
    player: Mpris.Player;
    colors: Accessor<Colors>;
    setColors: Setter<Colors>;
    props: Partial<Astal.CenterBox.ConstructorProps & { class: string }>;
}): PlayerBox =>
    new PlayerBox({
        ...props,
        vertical: true,

        bgStyle: '',
        player,

        setup: (self: PlayerBox) => {
            const setCover = () => {
                execAsync([
                    'bash',
                    '-c',
                    `[[ -f "${player.coverArt}" ]] &&
                  coloryou "${player.coverArt}" | grep -v Warning`,
                ])
                    .then((out) => {
                        if (!player.coverArt) {
                            return;
                        }

                        setColors(JSON.parse(out));

                        self.bgStyle = `
                        background: radial-gradient(circle,
                                    rgba(0, 0, 0, 0.4) 30%,
                                    ${colors().imageAccent}),
                                    url("${player.coverArt}");
                        background-size: cover;
                        background-position: center;
                    `;

                        if (!(self.get_parent() as PlayerGesture).dragging) {
                            setCss(self.cssProvider, self.bgStyle);
                        }
                    })
                    .catch(() => {
                        setColors({
                            imageAccent: '#6b4fa2',
                            buttonAccent: '#ecdcff',
                            buttonText: '#25005a',
                            hoverAccent: '#d4baff',
                        });

                        self.bgStyle = `
                        background: radial-gradient(circle,
                                    rgba(0, 0, 0, 0.4) 30%,
                                    ${colors().imageAccent}),
                                    rgb(0, 0, 0);
                        background-size: cover;
                        background-position: center;
                    `;
                        setCss(self.cssProvider, self.bgStyle);
                    });
            };

            player.connect('notify::cover-art', () => setCover());
            idle(() => setCover());
        },
    });

export const TitleLabel = (player: Mpris.Player) =>
    (
        <label
            xalign={0}
            max_width_chars={40}
            truncate
            justify={Gtk.Justification.LEFT}
            class="title"
            label={createBinding(player, 'title')}
        />
    ) as Astal.Label;

export const ArtistLabel = (player: Mpris.Player) =>
    (
        <label
            xalign={0}
            max_width_chars={40}
            truncate
            justify={Gtk.Justification.LEFT}
            class="artist"
            label={createBinding(player, 'artist')}
        />
    ) as Astal.Label;

export const PlayerIcon = (player: Mpris.Player, overlay: PlayerGesture) => {
    const playerIcon = (
        p: Mpris.Player,
        widget?: PlayerGesture,
        playerBox?: PlayerBox,
    ) =>
        (
            <button
                tooltip_text={p.identity || ''}
                onButtonReleaseEvent={() => {
                    if (widget && playerBox) {
                        widget.moveToTop(playerBox);
                    }
                }}
            >
                <icon
                    css={`
                        font-size: ${ICON_SIZE}px;
                    `}
                    class={widget ? 'position-indicator' : 'player-icon'}
                    $={(self) => {
                        idle(() => {
                            if (p.entry === null) {
                                return;
                            }

                            self.icon = Astal.Icon.lookup_icon(p.entry)
                                ? p.entry
                                : icons.mpris.fallback;
                        });
                    }}
                />
            </button>
        ) as Astal.Button;

    return (
        <box
            $={(self) => {
                const update = () => {
                    const grandPa = self.get_parent()?.get_parent();

                    if (!grandPa) {
                        return;
                    }

                    const thisIndex = overlay.overlays.indexOf(grandPa);

                    self.children = (overlay.overlays as PlayerBox[])
                        .map((playerBox, i) => {
                            self.children.push(
                                Separator({ size: 2 }) as Gtk.Widget,
                            );

                            return i === thisIndex
                                ? playerIcon(player)
                                : playerIcon(
                                      playerBox.player,
                                      overlay,
                                      playerBox,
                                  );
                        })
                        .reverse();
                };

                const mpris = Mpris.get_default();

                mpris.connect('player-added', update);
                mpris.connect('player-closed', update);

                idle(() => update());
            }}
        />
    ) as Astal.Box;
};

const display = Gdk.Display.get_default();

export const PositionSlider = (
    player: Mpris.Player,
    colors: Accessor<Colors>,
) =>
    (
        <slider
            class="position-slider"
            valign={Gtk.Align.CENTER}
            hexpand
            drawValue
            onDragged={({ value }) => {
                player.position = player.length * value;
            }}
            onButtonPressEvent={(self) => {
                if (!display) {
                    return;
                }
                self.window.set_cursor(
                    Gdk.Cursor.new_from_name(display, 'grabbing'),
                );
            }}
            onButtonReleaseEvent={(self) => {
                if (!display) {
                    return;
                }
                self.window.set_cursor(
                    Gdk.Cursor.new_from_name(display, 'pointer'),
                );
            }}
            onEnterNotifyEvent={(self) => {
                if (!display) {
                    return;
                }
                self.window.set_cursor(
                    Gdk.Cursor.new_from_name(display, 'pointer'),
                );
            }}
            onLeaveNotifyEvent={(self) => {
                self.window.set_cursor(null);
            }}
            $={(self) => {
                const provider = getCssProvider(self);

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

                colors.subscribe(() => {
                    if (colors()) {
                        const c = colors();

                        setCss(
                            provider,
                            `
                                highlight    { background-color: ${c.buttonAccent}; }
                                slider       { background-color: ${c.buttonAccent}; }
                                slider:hover { background-color: ${c.hoverAccent}; }
                                trough       { background-color: ${c.buttonText}; }
                            `,
                        );
                    }
                });

                player.connect('notify::position', () => update());
            }}
        />
    ) as Astal.Slider;

const PlayerButton = ({
    player,
    colors,
    children = [],
    onClick,
    prop,
}: {
    player: Mpris.Player;
    colors: Accessor<Colors>;
    children: Astal.Label[] | Astal.Icon[];
    onClick: keyof Mpris.Player;
    prop: keyof Mpris.Player;
}) => {
    let hovered = false;
    const stack = new Astal.Stack({ children });

    return (
        <cursor-button
            cursor="pointer"
            onButtonReleaseEvent={() => (player[onClick] as () => void)()}
            onHover={() => {
                hovered = true;

                if (prop === 'playbackStatus' && colors()) {
                    const c = colors();

                    children.forEach((ch) => {
                        setCss(
                            getCssProvider(ch),
                            `
                                background-color: ${c.hoverAccent};
                                color: ${c.buttonText};
                                min-height: 40px;
                                min-width: 36px;
                                margin-bottom: 1px;
                                margin-right: 1px;
                            `,
                        );
                    });
                }
            }}
            onHoverLost={() => {
                hovered = false;
                if (prop === 'playbackStatus' && colors()) {
                    const c = colors();

                    children.forEach((ch) => {
                        setCss(
                            getCssProvider(ch),
                            `
                                background-color: ${c.buttonAccent};
                                color: ${c.buttonText};
                                min-height: 42px;
                                min-width: 38px;
                            `,
                        );
                    });
                }
            }}
            $={(self) => {
                const selfProvider = getCssProvider(self);

                if (player[prop] && (player[prop] as boolean) !== false) {
                    stack.shown = String(player[prop]);
                }

                player.connect(`notify::${kebabify(prop)}`, () => {
                    if (player[prop] !== 0) {
                        stack.shown = String(player[prop]);
                    }
                });

                colors.subscribe(() => {
                    if (
                        !Mpris.get_default()
                            .get_players()
                            .find((p) => player === p)
                    ) {
                        return;
                    }

                    if (colors()) {
                        const c = colors();

                        if (prop === 'playbackStatus') {
                            if (hovered) {
                                children.forEach((ch) => {
                                    setCss(
                                        getCssProvider(ch),
                                        `
                                            background-color: ${c.hoverAccent};
                                            color: ${c.buttonText};
                                            min-height: 40px;
                                            min-width: 36px;
                                            margin-bottom: 1px;
                                            margin-right: 1px;
                                        `,
                                    );
                                });
                            }
                            else {
                                children.forEach((ch) => {
                                    setCss(
                                        getCssProvider(ch),
                                        `
                                            background-color: ${c.buttonAccent};
                                            color: ${c.buttonText};
                                            min-height: 42px;
                                            min-width: 38px;
                                        `,
                                    );
                                });
                            }
                        }
                        else {
                            setCss(
                                selfProvider,
                                `
                                    *       { color: ${c.buttonAccent}; }
                                    *:hover { color: ${c.hoverAccent}; }
                                `,
                            );
                        }
                    }
                });
            }}
        >
            {stack}
        </cursor-button>
    ) as Astal.Button;
};

export const ShuffleButton = (player: Mpris.Player, colors: Accessor<Colors>) =>
    PlayerButton({
        player,
        colors,
        children: [
            <label
                name={Mpris.Shuffle.ON.toString()}
                class="shuffle enabled"
                label={icons.mpris.shuffle.enabled}
            />,
            <label
                name={Mpris.Shuffle.OFF.toString()}
                class="shuffle disabled"
                label={icons.mpris.shuffle.disabled}
            />,
        ] as Astal.Label[],
        onClick: 'shuffle',
        prop: 'shuffleStatus',
    });

export const LoopButton = (player: Mpris.Player, colors: Accessor<Colors>) =>
    PlayerButton({
        player,
        colors,
        children: [
            <label
                name={Mpris.Loop.NONE.toString()}
                class="loop none"
                label={icons.mpris.loop.none}
            />,
            <label
                name={Mpris.Loop.TRACK.toString()}
                class="loop track"
                label={icons.mpris.loop.track}
            />,
            <label
                name={Mpris.Loop.PLAYLIST.toString()}
                class="loop playlist"
                label={icons.mpris.loop.playlist}
            />,
        ] as Astal.Label[],
        onClick: 'loop',
        prop: 'loopStatus',
    });

export const PlayPauseButton = ({
    player,
    colors,
}: {
    player: Mpris.Player;
    colors: Accessor<Colors>;
}) =>
    PlayerButton({
        player,
        colors,
        children: [
            <icon
                name={Mpris.PlaybackStatus.PLAYING.toString()}
                class="pausebutton playing"
                icon={icons.mpris.playing}
            />,
            <icon
                name={Mpris.PlaybackStatus.PAUSED.toString()}
                class="pausebutton paused"
                icon={icons.mpris.paused}
            />,
            <icon
                name={Mpris.PlaybackStatus.STOPPED.toString()}
                class="pausebutton stopped paused"
                icon={icons.mpris.stopped}
            />,
        ] as Astal.Icon[],
        onClick: 'play_pause',
        prop: 'playbackStatus',
    });

export const PreviousButton = (
    player: Mpris.Player,
    colors: Accessor<Colors>,
) =>
    PlayerButton({
        player,
        colors,
        children: [
            <label name="true" class="previous" label={icons.mpris.prev} />,
            <label name="false" class="previous" label={icons.mpris.prev} />,
        ] as Astal.Label[],
        onClick: 'previous',
        prop: 'canGoPrevious',
    });

export const NextButton = (player: Mpris.Player, colors: Accessor<Colors>) =>
    PlayerButton({
        player,
        colors,
        children: [
            <label name="true" class="next" label={icons.mpris.next} />,
            <label name="false" class="next" label={icons.mpris.next} />,
        ] as Astal.Label[],
        onClick: 'next',
        prop: 'canGoNext',
    });

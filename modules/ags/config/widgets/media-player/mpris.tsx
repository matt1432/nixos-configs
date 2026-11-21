import { Astal, Gdk, Gtk } from 'ags/gtk4';
import { execAsync } from 'ags/process';
import { idle, interval } from 'ags/time';
import Mpris from 'gi://AstalMpris';
import Pango from 'gi://Pango';
import { Accessor, createBinding, createRoot, Setter } from 'gnim';

import { cursor, pointer, setCss } from '../../lib/widgets';
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

const kebabify = (str: string) =>
    str
        .replace(/([a-z])([A-Z])/g, '$1-$2')
        .replaceAll('_', '-')
        .toLowerCase();

const hasIcon = (name: string) => {
    const display = Gdk.Display.get_default();

    return display
        ? Gtk.IconTheme.get_for_display(display).has_icon(name)
        : false;
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
    props: Partial<Gtk.CenterBox.ConstructorProps & { class: string }>;
}): PlayerBox => {
    const { class: className, ...rest } = props;

    const box = new PlayerBox({
        ...rest,
        orientation: Gtk.Orientation.VERTICAL,

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
                                    url("file://${player.coverArt}");
                        background-size: cover;
                        background-position: center;
                    `;

                        if (!(self.get_parent() as PlayerGesture).dragging) {
                            setCss(self, self.bgStyle);
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
                        setCss(self, self.bgStyle);
                    });
            };

            player.connect('notify::cover-art', () => setCover());
            idle(() => setCover());
        },
    });

    if (className) {
        box.set_css_classes(className.split(/\s+/));
    }

    return box;
};

export const TitleLabel = (player: Mpris.Player) =>
    (
        <label
            xalign={0}
            maxWidthChars={40}
            ellipsize={Pango.EllipsizeMode.END}
            justify={Gtk.Justification.LEFT}
            class="title"
            label={createBinding(player, 'title').as((t) => t ?? '')}
        />
    ) as Gtk.Label;

export const ArtistLabel = (player: Mpris.Player) =>
    (
        <label
            xalign={0}
            maxWidthChars={40}
            ellipsize={Pango.EllipsizeMode.END}
            justify={Gtk.Justification.LEFT}
            class="artist"
            label={createBinding(player, 'artist').as((a) => a ?? '')}
        />
    ) as Gtk.Label;

export const PlayerIcon = (player: Mpris.Player, overlay: PlayerGesture) => {
    const playerIcon = (
        p: Mpris.Player,
        widget?: PlayerGesture,
        playerBox?: PlayerBox,
    ) =>
        (
            <button
                tooltipText={p.identity || ''}
                onClicked={() => {
                    if (widget && playerBox) {
                        widget.moveToTop(playerBox);
                    }
                }}
            >
                <image
                    pixelSize={ICON_SIZE}
                    class={widget ? 'position-indicator' : 'player-icon'}
                    $={(self) => {
                        idle(() => {
                            if (p.entry === null) {
                                return;
                            }

                            self.iconName = hasIcon(p.entry)
                                ? p.entry
                                : icons.mpris.fallback;
                        });
                    }}
                />
            </button>
        ) as Gtk.Button;

    return (
        <box
            $={(self) => {
                let disposeIcons: (() => void) | undefined;

                const update = () => {
                    const grandPa = self.get_parent()?.get_parent();

                    if (!grandPa) {
                        return;
                    }

                    const thisIndex = overlay.overlays.indexOf(
                        grandPa as PlayerBox,
                    );

                    for (
                        let child = self.get_first_child();
                        child;
                        child = self.get_first_child()
                    ) {
                        self.remove(child);
                    }

                    disposeIcons?.();

                    createRoot((dispose) => {
                        disposeIcons = dispose;

                        overlay.overlays
                            .map((playerBox, i) =>
                                i === thisIndex
                                    ? playerIcon(player)
                                    : playerIcon(
                                          playerBox.player,
                                          overlay,
                                          playerBox,
                                      ),
                            )
                            .reverse()
                            .forEach((w) => self.append(w));
                    });
                };

                const mpris = Mpris.get_default();

                mpris.connect('player-added', update);
                mpris.connect('player-closed', update);

                idle(() => update());
            }}
        />
    ) as Gtk.Box;
};

let sliderCount = 0;

export const PositionSlider = (
    player: Mpris.Player,
    colors: Accessor<Colors>,
) => {
    let dragging = false;

    return (
        <slider
            class="position-slider"
            valign={Gtk.Align.CENTER}
            hexpand
            drawValue
            cursor={pointer}
            onChangeValue={(_, __, value) => {
                player.position = player.length * value;
            }}
            $={(self) => {
                // Observe presses without stealing them from the slider
                const click = new Gtk.GestureClick({
                    propagationPhase: Gtk.PropagationPhase.CAPTURE,
                });

                click.connect('pressed', () => {
                    dragging = true;
                    self.set_cursor(cursor('grabbing'));
                });
                click.connect('released', () => {
                    dragging = false;
                    self.set_cursor(pointer);
                });
                click.connect('stopped', () => {
                    dragging = false;
                    self.set_cursor(pointer);
                });
                self.add_controller(click);

                const update = () => {
                    if (!dragging) {
                        self.visible = player.length > 0;
                        if (player.length > 0) {
                            self.value = player.position / player.length;
                        }
                    }
                };

                const timer = interval(1000, () => update());

                Mpris.get_default().connect('player-closed', (_, p) => {
                    if (p === player) {
                        timer.cancel();
                    }
                });

                // A widget's own CSS provider doesn't reach its sub-widgets
                // in Gtk4, so the trough/slider colors use a display-wide
                // provider scoped by a unique class
                const sliderClass = `position-slider-${++sliderCount}`;
                let provider: Gtk.CssProvider | undefined;

                self.add_css_class(sliderClass);

                colors.subscribe(() => {
                    const display = Gdk.Display.get_default();

                    if (colors() && display) {
                        const c = colors();
                        const sel = `.${sliderClass}`;

                        if (provider) {
                            Gtk.StyleContext.remove_provider_for_display(
                                display,
                                provider,
                            );
                        }

                        provider = new Gtk.CssProvider();
                        provider.load_from_string(`
                            ${sel} highlight    { background-color: ${c.buttonAccent}; }
                            ${sel} slider       { background-color: ${c.buttonAccent}; }
                            ${sel} slider:hover { background-color: ${c.hoverAccent}; }
                            ${sel} trough       { background-color: ${c.buttonText}; }
                        `);
                        Gtk.StyleContext.add_provider_for_display(
                            display,
                            provider,
                            Gtk.STYLE_PROVIDER_PRIORITY_USER,
                        );
                    }
                });

                player.connect('notify::position', () => update());
            }}
        />
    ) as Astal.Slider;
};

const PlayerButton = ({
    player,
    colors,
    children = [],
    onClick,
    prop,
}: {
    player: Mpris.Player;
    colors: Accessor<Colors>;
    children: Gtk.Widget[];
    onClick: keyof Mpris.Player;
    prop: keyof Mpris.Player;
}) => {
    let hovered = false;
    const stack = new Gtk.Stack();

    children.forEach((ch) => stack.add_named(ch, ch.name));

    const setChildrenCss = (c: Colors) => {
        children.forEach((ch) => {
            setCss(
                ch,
                hovered
                    ? `
                        background-color: ${c.hoverAccent};
                        color: ${c.buttonText};
                        min-height: 40px;
                        min-width: 36px;
                        margin-bottom: 1px;
                        margin-right: 1px;
                    `
                    : `
                        background-color: ${c.buttonAccent};
                        color: ${c.buttonText};
                        min-height: 42px;
                        min-width: 38px;
                    `,
            );
        });
    };

    return (
        <button
            cursor={pointer}
            onClicked={() => (player[onClick] as () => void)()}
            $={(self) => {
                const motion = new Gtk.EventControllerMotion();

                motion.connect('enter', () => {
                    hovered = true;

                    if (prop === 'playbackStatus' && colors()) {
                        setChildrenCss(colors());
                    }
                });
                motion.connect('leave', () => {
                    hovered = false;

                    if (prop === 'playbackStatus' && colors()) {
                        setChildrenCss(colors());
                    }
                });
                self.add_controller(motion);

                if (player[prop] && (player[prop] as boolean) !== false) {
                    stack.visibleChildName = String(player[prop]);
                }

                player.connect(`notify::${kebabify(prop)}`, () => {
                    if (player[prop] !== 0) {
                        stack.visibleChildName = String(player[prop]);
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
                            setChildrenCss(c);
                        }
                        else {
                            setCss(
                                self,
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
        </button>
    ) as Gtk.Button;
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
        ] as Gtk.Widget[],
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
        ] as Gtk.Widget[],
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
            <image
                name={Mpris.PlaybackStatus.PLAYING.toString()}
                class="pausebutton playing"
                iconName={icons.mpris.playing}
            />,
            <image
                name={Mpris.PlaybackStatus.PAUSED.toString()}
                class="pausebutton paused"
                iconName={icons.mpris.paused}
            />,
            <image
                name={Mpris.PlaybackStatus.STOPPED.toString()}
                class="pausebutton stopped paused"
                iconName={icons.mpris.stopped}
            />,
        ] as Gtk.Widget[],
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
        ] as Gtk.Widget[],
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
        ] as Gtk.Widget[],
        onClick: 'next',
        prop: 'canGoNext',
    });

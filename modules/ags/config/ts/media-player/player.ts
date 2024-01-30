const Mpris = await Service.import('mpris');

const { Box, CenterBox } = Widget;

import * as mpris from './mpris.ts';
import PlayerGesture from './gesture.ts';
import Separator from '../misc/separator.ts';

const FAVE_PLAYER = 'org.mpris.MediaPlayer2.spotify';
const SPACING = 8;

// Types
import { MprisPlayer } from 'types/service/mpris.ts';
import { Variable as Var } from 'types/variable';
import { Colors, PlayerBox, PlayerOverlay } from 'global-types';


const Top = (
    player: MprisPlayer,
    overlay: PlayerOverlay,
) => Box({
    class_name: 'top',
    hpack: 'start',
    vpack: 'start',

    children: [
        mpris.PlayerIcon(player, overlay),
    ],
});

const Center = (
    player: MprisPlayer,
    colors: Var<Colors>,
) => Box({
    class_name: 'center',

    children: [
        CenterBox({
            vertical: true,

            start_widget: Box({
                class_name: 'metadata',
                vertical: true,
                hpack: 'start',
                vpack: 'center',
                hexpand: true,

                children: [
                    mpris.TitleLabel(player),
                    mpris.ArtistLabel(player),
                ],
            }),
        }),

        CenterBox({
            vertical: true,

            center_widget: mpris.PlayPauseButton(player, colors),
        }),

    ],
});

const Bottom = (
    player: MprisPlayer,
    colors: Var<Colors>,
) => Box({
    class_name: 'bottom',

    children: [
        mpris.PreviousButton(player, colors),
        Separator(SPACING),

        mpris.PositionSlider(player, colors),
        Separator(SPACING),

        mpris.NextButton(player, colors),
        Separator(SPACING),

        mpris.ShuffleButton(player, colors),
        Separator(SPACING),

        mpris.LoopButton(player, colors),
    ],
});

const PlayerBox = (
    player: MprisPlayer,
    colors: Var<Colors>,
    overlay: PlayerOverlay,
) => {
    const widget = mpris.CoverArt(player, colors, {
        class_name: `player ${player.name}`,
        hexpand: true,

        start_widget: Top(player, overlay),
        center_widget: Center(player, colors),
        end_widget: Bottom(player, colors),
    });

    widget.visible = false;

    return widget;
};

export default () => {
    const content = PlayerGesture({
        setup: (self: PlayerOverlay) => {
            self
                .hook(Mpris, (_, bus_name) => {
                    const players = self.attribute.players;

                    if (players.has(bus_name)) {
                        return;
                    }

                    // Sometimes the signal doesn't give the bus_name
                    if (!bus_name) {
                        const player = Mpris.players.find((p) => {
                            return !players.has(p.bus_name);
                        });

                        if (player) {
                            bus_name = player.bus_name;
                        }
                        else {
                            return;
                        }
                    }

                    // Get the one on top so we can move it up later
                    const previousFirst = self.overlays.at(-1) as PlayerBox;

                    // Make the new player
                    const player = Mpris.getPlayer(bus_name);
                    const colorsVar = Variable({
                        imageAccent: '#6b4fa2',
                        buttonAccent: '#ecdcff',
                        buttonText: '#25005a',
                        hoverAccent: '#d4baff',
                    });

                    if (!player) {
                        return;
                    }

                    players.set(
                        bus_name,
                        PlayerBox(player, colorsVar, self),
                    );
                    self.overlays = Array.from(players.values())
                        .map((widget) => widget) as PlayerBox[];

                    const includes = self.attribute
                        .includesWidget(previousFirst);

                    // Select favorite player at startup
                    const attrs = self.attribute;

                    if (!attrs.setup && players.has(FAVE_PLAYER)) {
                        attrs.moveToTop(players.get(FAVE_PLAYER));
                        attrs.setup = true;
                    }

                    // Move previousFirst on top again
                    else if (includes) {
                        attrs.moveToTop(previousFirst);
                    }
                }, 'player-added')

                .hook(Mpris, (_, bus_name) => {
                    const players = self.attribute.players;

                    if (!bus_name || !players.has(bus_name)) {
                        return;
                    }

                    // Get the one on top so we can move it up later
                    const previousFirst = self.overlays.at(-1) as PlayerBox;

                    // Remake overlays without deleted one
                    players.delete(bus_name);
                    self.overlays = Array.from(players.values())
                        .map((widget) => widget) as PlayerBox[];

                    // Move previousFirst on top again
                    const includes = self.attribute
                        .includesWidget(previousFirst);

                    if (includes) {
                        self.attribute.moveToTop(previousFirst);
                    }
                }, 'player-closed');
        },
    });

    return Box({
        class_name: 'media',
        child: content,
    });
};

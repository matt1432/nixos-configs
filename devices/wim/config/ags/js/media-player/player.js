import Mpris from 'resource:///com/github/Aylur/ags/service/mpris.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';

import { Box, CenterBox } from 'resource:///com/github/Aylur/ags/widget.js';

import * as mpris from './mpris.js';
import PlayerGesture from './gesture.js';
import Separator from '../misc/separator.js';

const FAVE_PLAYER = 'org.mpris.MediaPlayer2.spotify';
const SPACING = 8;

/**
 * @typedef {import('types/service/mpris').MprisPlayer} Player
 * @typedef {import('types/widgets/overlay').default} Overlay
 * @typedef {import('types/variable').Variable} Variable
 */


/**
 * @param {Player} player
 * @param {Overlay} overlay
 */
const Top = (player, overlay) => Box({
    class_name: 'top',
    hpack: 'start',
    vpack: 'start',

    children: [
        mpris.PlayerIcon(player, overlay),
    ],
});

/**
 * @param {Player} player
 * @param {Variable} colors
 */
const Center = (player, colors) => Box({
    class_name: 'center',

    children: [
        CenterBox({
            // @ts-expect-error
            vertical: true,

            children: [
                Box({
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
                null,
                null,
            ],
        }),

        CenterBox({
            // @ts-expect-error
            vertical: true,

            children: [
                null,
                mpris.PlayPauseButton(player, colors),
                null,
            ],
        }),

    ],
});

/**
 * @param {Player} player
 * @param {Variable} colors
 */
const Bottom = (player, colors) => Box({
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

/**
 * @param {Player} player
 * @param {Variable} colors
 * @param {Overlay} overlay
 */
const PlayerBox = (player, colors, overlay) => {
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
        attribute: {
            players: new Map(),
            setup: false,
        },

        setup: /** @param {any} self */ (self) => {
            self
                .hook(Mpris,
                    /**
                     * @param {Overlay} overlay
                     * @param {string} bus_name
                     */
                    (overlay, bus_name) => {
                        const players = overlay.attribute.players;

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
                        const previousFirst = overlay.attribute.list().at(-1);

                        // Make the new player
                        const player = Mpris.getPlayer(bus_name);
                        const Colors = Variable(null);

                        if (!player) {
                            return;
                        }

                        players.set(
                            bus_name,
                            // @ts-expect-error
                            PlayerBox(player, Colors, content.child),
                        );
                        overlay.overlays = Array.from(players.values())
                            .map((widget) => widget);

                        const includes = overlay.attribute
                            .includesWidget(previousFirst);

                        // Select favorite player at startup
                        const attrs = overlay.attribute;

                        if (!attrs.setup && players.has(FAVE_PLAYER)) {
                            attrs.moveToTop(players.get(FAVE_PLAYER));
                            attrs.setup = true;
                        }

                        // Move previousFirst on top again
                        else if (includes) {
                            attrs.moveToTop(previousFirst);
                        }
                    },
                    'player-added')

                .hook(Mpris,
                    /**
                     * @param {Overlay} overlay
                     * @param {string} bus_name
                     */
                    (overlay, bus_name) => {
                        const players = overlay.attribute.players;

                        if (!bus_name || !players.has(bus_name)) {
                            return;
                        }

                        // Get the one on top so we can move it up later
                        const previousFirst = overlay.attribute.list().at(-1);

                        // Remake overlays without deleted one
                        players.delete(bus_name);
                        overlay.overlays = Array.from(players.values())
                            .map((widget) => widget);

                        // Move previousFirst on top again
                        const includes = overlay.attribute
                            .includesWidget(previousFirst);

                        if (includes) {
                            overlay.attribute.moveToTop(previousFirst);
                        }
                    },
                    'player-closed');
        },
    });

    return Box({
        class_name: 'media',
        child: content,
    });
};

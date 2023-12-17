import Mpris from 'resource:///com/github/Aylur/ags/service/mpris.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';

import { Box, CenterBox } from 'resource:///com/github/Aylur/ags/widget.js';

import * as mpris from './mpris.js';
import PlayerGesture from './gesture.js';
import Separator from '../misc/separator.js';

const FAVE_PLAYER = 'org.mpris.MediaPlayer2.spotify';


const Top = (player, overlay) => Box({
    className: 'top',
    hpack: 'start',
    vpack: 'start',

    children: [
        mpris.PlayerIcon(player, overlay),
    ],
});

const Center = (player) => Box({
    className: 'center',

    children: [
        CenterBox({
            vertical: true,

            children: [
                Box({
                    className: 'metadata',
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
            vertical: true,

            children: [
                null,
                mpris.PlayPauseButton(player),
                null,
            ],
        }),

    ],
});

const SPACING = 8;

const Bottom = (player) => Box({
    className: 'bottom',

    children: [
        mpris.PreviousButton(player, {
            vpack: 'end',
            hpack: 'start',
        }),
        Separator(SPACING),

        mpris.PositionSlider(player),
        Separator(SPACING),

        mpris.NextButton(player),
        Separator(SPACING),

        mpris.ShuffleButton(player),
        Separator(SPACING),

        mpris.LoopButton(player),
    ],
});

const PlayerBox = (player, overlay) => {
    const widget = mpris.CoverArt(player, {
        className: `player ${player.name}`,
        hexpand: true,

        children: [
            Top(player, overlay),
            Center(player),
            Bottom(player),
        ],
    });

    widget.visible = false;

    return widget;
};

export default () => {
    const content = PlayerGesture({
        properties: [
            ['players', new Map()],
            ['setup', false],
        ],

        setup: (self) => {
            self
                .hook(Mpris, (overlay, busName) => {
                    if (overlay._players.has(busName)) {
                        return;
                    }

                    // Sometimes the signal doesn't give the busName
                    if (!busName) {
                        const player = Mpris.players.find((p) => {
                            return !overlay._players.has(p.busName);
                        });

                        if (player) {
                            busName = player.busName;
                        }
                        else {
                            return;
                        }
                    }

                    // Get the one on top so we can move it up later
                    const previousFirst = overlay.list().at(-1);

                    // Make the new player
                    const player = Mpris.getPlayer(busName);

                    player.colors = Variable();
                    overlay._players.set(
                        busName,
                        PlayerBox(player, content.getOverlay()),
                    );
                    overlay.overlays = Array.from(overlay._players.values())
                        .map((widget) => widget);

                    // Select favorite player at startup
                    if (!overlay._setup && overlay._players.has(FAVE_PLAYER)) {
                        overlay.moveToTop(overlay._players.get(FAVE_PLAYER));
                        overlay._setup = true;
                    }

                    // Move previousFirst on top again
                    else if (overlay.includesWidget(previousFirst)) {
                        overlay.moveToTop(previousFirst);
                    }
                }, 'player-added')

                .hook(Mpris, (overlay, busName) => {
                    if (!busName || !overlay._players.has(busName)) {
                        return;
                    }

                    // Get the one on top so we can move it up later
                    const previousFirst = overlay.list().at(-1);

                    // Remake overlays without deleted one
                    overlay._players.delete(busName);
                    overlay.overlays = Array.from(overlay._players.values())
                        .map((widget) => widget);

                    // Move previousFirst on top again
                    if (overlay.includesWidget(previousFirst)) {
                        overlay.moveToTop(previousFirst);
                    }
                }, 'player-closed');
        },
    });

    return Box({
        className: 'media',
        child: content,
    });
};

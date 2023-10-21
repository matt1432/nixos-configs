import { Mpris, Variable, Widget } from '../../imports.js';
const { Box, CenterBox } = Widget;

import * as mpris    from './mpris.js';
import PlayerGesture from './gesture.js';
import Separator     from '../misc/separator.js';

const FAVE_PLAYER = 'org.mpris.MediaPlayer2.spotify';


const Top = player => Box({
    className: 'top',
    halign: 'start',
    valign: 'start',
    children: [
        mpris.PlayerIcon(player, {
            symbolic: false,
        }),
    ],
});

const Center = player => Box({
    className: 'center',
    children: [

        CenterBox({
            vertical: true,
            children: [
                Box({
                    className: 'metadata',
                    vertical: true,
                    halign: 'start',
                    valign: 'center',
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

const Bottom = player => Box({
    className: 'bottom',
    children: [
        mpris.PreviousButton(player, {
            valign: 'end',
            halign: 'start',
        }),
        Separator(8),

        mpris.PositionSlider(player),
        Separator(8),

        mpris.NextButton(player),
        Separator(8),

        mpris.ShuffleButton(player),
        Separator(8),

        mpris.LoopButton(player),
    ],
});

const PlayerBox = player => mpris.CoverArt(player, {
    className: `player ${player.name}`,
    hexpand: true,
    children: [
        Top(player),
        Center(player),
        Bottom(player),
    ],
});

export default () => Box({
    className: 'media',
    child: PlayerGesture({
        properties: [
            ['players', new Map()],
            ['setup', false],
            ['selected'],
        ],
        connections: [
            [Mpris, (overlay, busName) => {
                if (overlay._players.has(busName))
                    return;

                if (!busName) {
                    const player = Mpris.players.find(p => !overlay._players.has(p.busName));
                    if (player)
                        busName = player.busName;
                    else
                        return;
                }

                const player = Mpris.getPlayer(busName);
                player.colors = Variable();
                overlay._players.set(busName, PlayerBox(player));

                const result = [];
                overlay._players.forEach(widget => {
                    result.push(widget);
                });

                overlay.overlays = result;

                // Select favorite player at startup
                if (!overlay._setup) {
                    if (overlay._players.has(FAVE_PLAYER))
                        overlay._selected = overlay._players.get(FAVE_PLAYER);

                    overlay._setup = true;
                }

                if (overlay._selected)
                    overlay.reorder_overlay(overlay._selected, -1);
            }, 'player-added'],


            [Mpris, (overlay, busName) => {
                if (!busName || !overlay._players.has(busName))
                    return;

                overlay._players.delete(busName);

                const result = [];
                overlay._players.forEach(widget => {
                    result.push(widget);
                });

                overlay.overlays = result;
                if (overlay._selected)
                    overlay.reorder_overlay(overlay._selected, -1);
            }, 'player-closed'],
        ],
    }),
});

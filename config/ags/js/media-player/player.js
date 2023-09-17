const { Mpris } = ags.Service;
const { Box, CenterBox, Label } = ags.Widget;

import * as mpris from './mpris.js';
import { Separator } from '../misc/separator.js';

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

        Label(),
        Label(),
      ],
    }),

    CenterBox({
      vertical: true,
      children: [
        Label(),
        mpris.PlayPauseButton(player),
        Label(),
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
    vertical: true,
    className: 'media',
    properties: [['players', new Map()]],
    connections: [
        [Mpris, (box, busName) => {
            if (!busName || box._players.has(busName))
                return;

            const player = Mpris.getPlayer(busName);
            box._players.set(busName, PlayerBox(player));
            box.children = Array.from(box._players.values());
        }, 'player-added'],
        [Mpris, (box, busName) => {
            if (!busName || !box._players.has(busName))
                return;

            box._players.delete(busName);
            box.children = Array.from(box._players.values());
        }, 'player-closed'],
    ],
});

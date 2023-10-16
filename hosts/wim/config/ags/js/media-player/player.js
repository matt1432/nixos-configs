import { Mpris, Variable, Widget } from '../../imports.js';
const { Box, CenterBox, Label } = Widget;

import * as mpris from './mpris.js';
import PlayerGesture from './gesture.js';
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
  className: 'media',
  child: PlayerGesture({
    properties: [
      ['players', new Map()],
      ['setup', false],
      ['selected'],
    ],
    connections: [
      [Mpris, (overlay, busName) => {
        if (!busName || overlay._players.has(busName))
          return;

        const player = Mpris.getPlayer(busName);
        player.colors = Variable();
        overlay._players.set(busName, PlayerBox(player));

        let result = [];
        overlay._players.forEach(widget => {
          result.push(widget);
        });

        overlay.overlays = result;

        // Favor spotify
        if (!overlay._setup) {
          if (overlay._players.has('org.mpris.MediaPlayer2.spotify')) {
            overlay._selected = overlay._players.get('org.mpris.MediaPlayer2.spotify');
          }
          overlay._setup = true;
        }

        if (overlay._selected)
          overlay.reorder_overlay(overlay._selected, -1);
      }, 'player-added'],

      [Mpris, (overlay, busName) => {
        if (!busName || !overlay._players.has(busName))
          return;

        overlay._players.delete(busName);

        let result = [];
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

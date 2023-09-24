const { Mpris } = ags.Service;
const { Box, CenterBox, Label, Stack, EventBox } = ags.Widget;
const { Gtk } = imports.gi;

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

export default () => {
  let widget = EventBox();

  let gesture = Gtk.GestureDrag.new(widget)

  widget.child = Stack({
    className: 'media',
    properties: [
      ['players', new Map()],
      ['previous', 'spotify'],
    ],
    connections: [
      [gesture, stack => {
        const offset = gesture.get_offset()[1];
        if (Math.abs(offset) > 200) {
          let players = [];
          stack._players.forEach((_, busName) => players.push(Mpris.getPlayer(busName).name));
          let current = players.findIndex(player => player === stack.shown);

          if (offset > 0) {
            stack.transition = 'slide_right';
            if (players[++current])
              stack.shown = `${players[current]}`;
            else
              stack.shown = `${players[0]}`;
          }
          else {
            stack.transition = 'slide_left';
            if (players[--current])
              stack.shown = `${players[current]}`;
            else
              stack.shown = `${players.at(-1)}`;
          }
          stack._previous = stack.shown;
        }
      }, 'drag-end'],

      [Mpris, (stack, busName) => {
        if (!busName || stack._players.has(busName))
          return;

        const player = Mpris.getPlayer(busName);
        player.colors = ags.Variable();
        stack._players.set(busName, PlayerBox(player));

        let result = [];
        stack._players.forEach((widget, busName) => {
          result.push([`${Mpris.getPlayer(busName).name}`, widget]);
        });

        stack.items = result;
        if (result.find(p => p[0] === stack._previous))
          stack.shown = stack._previous;
        else if (stack._players.has('org.mpris.MediaPlayer2.spotify'))
          stack.shown = `spotify`;
      }, 'player-added'],

      [Mpris, (stack, busName) => {
        if (!busName || !stack._players.has(busName))
          return;

        stack._players.delete(busName);

        let result = [];
        stack._players.forEach((widget, busName) => {
          result.push([`${Mpris.getPlayer(busName).name}`, widget]);
        });

        stack.items = result;
        if (result.find(p => p[0] === stack._previous))
          stack.shown = stack._previous;
        else if (stack._players.has('org.mpris.MediaPlayer2.spotify'))
          stack.shown = `spotify`;
      }, 'player-closed'],
    ],
  });
  return widget;
};

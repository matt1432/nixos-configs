import { Variable } from 'astal';
import { Gtk } from 'astal/gtk3';
import { Box, CenterBox } from 'astal/gtk3/widget';
import Mpris from 'gi://AstalMpris';

import Separator from '../misc/separator';
import PlayerGesture, {
    PlayerBox as PlayerBoxClass,
    PlayerGesture as PlayerGestureClass,
} from './gesture';
import * as mpris from './mpris';

const FAVE_PLAYER = 'org.mpris.MediaPlayer2.spotify';
const SPACING = 8;

const Top = (player: Mpris.Player, overlay: PlayerGestureClass) =>
    new Box({
        className: 'top',
        halign: Gtk.Align.START,
        valign: Gtk.Align.START,

        children: [mpris.PlayerIcon(player, overlay)],
    });

const Center = (player: Mpris.Player, colors: Variable<mpris.Colors>) =>
    new Box({
        className: 'center',

        children: [
            new CenterBox({
                vertical: true,

                start_widget: new Box({
                    className: 'metadata',
                    vertical: true,
                    halign: Gtk.Align.START,
                    valign: Gtk.Align.CENTER,
                    hexpand: true,

                    children: [
                        mpris.TitleLabel(player),
                        mpris.ArtistLabel(player),
                    ],
                }),
            }),

            new CenterBox({
                vertical: true,

                center_widget: mpris.PlayPauseButton(player, colors),
            }),
        ],
    });

const Bottom = (player: Mpris.Player, colors: Variable<mpris.Colors>) =>
    new Box({
        className: 'bottom',

        children: [
            mpris.PreviousButton(player, colors),
            Separator({ size: SPACING }),

            mpris.PositionSlider(player, colors),
            Separator({ size: SPACING }),

            mpris.NextButton(player, colors),
            Separator({ size: SPACING }),

            mpris.ShuffleButton(player, colors),
            Separator({ size: SPACING }),

            mpris.LoopButton(player, colors),
        ],
    });

const PlayerBox = (
    player: Mpris.Player,
    colors: Variable<mpris.Colors>,
    overlay: PlayerGestureClass,
) => {
    const widget = mpris.CoverArt(player, colors, {
        className: `player ${player.identity}`,
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
        setup: (self) => {
            const addPlayer = (player: Mpris.Player) => {
                if (!player || self.players.has(player.bus_name)) {
                    return;
                }

                // Get the one on top so we can move it up later
                const previousFirst = self.overlays.at(-1) as PlayerBoxClass;

                // Make the new player
                const colorsVar = Variable({
                    imageAccent: '#6b4fa2',
                    buttonAccent: '#ecdcff',
                    buttonText: '#25005a',
                    hoverAccent: '#d4baff',
                });

                self.players.set(
                    player.bus_name,
                    PlayerBox(player, colorsVar, self),
                );
                self.add_overlay(self.players.get(player.bus_name));

                // Select favorite player at startup
                if (!self.setup && self.players.has(FAVE_PLAYER)) {
                    self.moveToTop(self.players.get(FAVE_PLAYER));
                    self.setup = true;
                }

                // Move previousFirst on top again
                else {
                    self.moveToTop(previousFirst);
                }
            };

            const removePlayer = (player: Mpris.Player) => {
                if (!player || !self.players.has(player.bus_name)) {
                    return;
                }

                const toDelete = self.players.get(player.bus_name);

                // Get the one on top so we can move it up later
                const previousFirst = self.overlays.at(-1) as PlayerBoxClass;

                // Move previousFirst on top again
                if (previousFirst !== toDelete) {
                    self.moveToTop(previousFirst);
                }
                else {
                    self.moveToTop(
                        self.players.has(FAVE_PLAYER)
                            ? self.players.get(FAVE_PLAYER)
                            : self.overlays[0],
                    );
                }

                // Remake overlays without deleted one
                self.remove(toDelete);
                self.players.delete(player.bus_name);
            };

            const mprisDefault = Mpris.get_default();

            self.hook(mprisDefault, 'player-added', (_, player) =>
                addPlayer(player),
            );
            self.hook(mprisDefault, 'player-closed', (_, player) =>
                removePlayer(player),
            );

            mprisDefault.players.forEach(addPlayer);
        },
    });

    return new Box({
        className: 'media-player',
        child: content,
    });
};

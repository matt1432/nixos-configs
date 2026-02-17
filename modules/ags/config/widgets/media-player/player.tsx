import { Astal, Gtk } from 'ags/gtk3';
import Mpris from 'gi://AstalMpris';
import { Accessor, createState, Setter } from 'gnim';

import Separator from '../misc/separator';
import PlayerGesture, {
    PlayerBox as PlayerBoxClass,
    PlayerGesture as PlayerGestureClass,
} from './gesture';
import * as mpris from './mpris';

const FAVE_PLAYER = 'org.mpris.MediaPlayer2.spotify';
const SPACING = 8;

const Top = (player: Mpris.Player, overlay: PlayerGestureClass) =>
    (
        <box class="top" halign={Gtk.Align.START} valign={Gtk.Align.START}>
            {mpris.PlayerIcon(player, overlay)}
        </box>
    ) as Astal.Box;

const Center = (player: Mpris.Player, colors: Accessor<mpris.Colors>) =>
    (
        <box class="center">
            <centerbox
                vertical
                start_widget={
                    (
                        <box
                            $type="start"
                            class="metadata"
                            vertical
                            halign={Gtk.Align.START}
                            valign={Gtk.Align.CENTER}
                            hexpand
                        >
                            {mpris.TitleLabel(player)}
                            {mpris.ArtistLabel(player)}
                        </box>
                    ) as Astal.Box
                }
            />

            <centerbox
                vertical
                center_widget={
                    (
                        <mpris.PlayPauseButton
                            $type="center"
                            player={player}
                            colors={colors}
                        />
                    ) as Astal.Button
                }
            />
        </box>
    ) as Astal.Box;

const Bottom = (player: Mpris.Player, colors: Accessor<mpris.Colors>) =>
    (
        <box class="bottom">
            {mpris.PreviousButton(player, colors)}
            <Separator size={SPACING} />

            {mpris.PositionSlider(player, colors)}
            <Separator size={SPACING} />

            {mpris.NextButton(player, colors)}
            <Separator size={SPACING} />

            {mpris.ShuffleButton(player, colors)}
            <Separator size={SPACING} />

            {mpris.LoopButton(player, colors)}
        </box>
    ) as Astal.Box;

const PlayerBox = (
    player: Mpris.Player,
    colors: Accessor<mpris.Colors>,
    setColors: Setter<mpris.Colors>,
    overlay: PlayerGestureClass,
) => {
    const widget = (
        <mpris.CoverArt
            player={player}
            colors={colors}
            setColors={setColors}
            props={{
                class: `player ${player.identity}`,
                hexpand: true,

                start_widget: Top(player, overlay),
                center_widget: Center(player, colors),
                end_widget: Bottom(player, colors),
            }}
        />
    ) as PlayerBoxClass;

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
                const [colorsVar, setColorsVar] = createState({
                    imageAccent: '#6b4fa2',
                    buttonAccent: '#ecdcff',
                    buttonText: '#25005a',
                    hoverAccent: '#d4baff',
                });

                self.players.set(
                    player.bus_name,
                    PlayerBox(player, colorsVar, setColorsVar, self),
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

            const mpris = Mpris.get_default();

            mpris.connect('player-added', (_, player) => addPlayer(player));
            mpris.connect('player-closed', (_, player) => removePlayer(player));

            mpris.players.forEach(addPlayer);
        },
    });

    return (<box class="media-player">{content}</box>) as Astal.Box;
};

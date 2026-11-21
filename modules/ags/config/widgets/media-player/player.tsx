import { Gtk } from 'ags/gtk4';
import Mpris from 'gi://AstalMpris';
import { Accessor, createRoot, createState, Setter } from 'gnim';

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
    ) as Gtk.Box;

const Center = (player: Mpris.Player, colors: Accessor<mpris.Colors>) =>
    (
        <box class="center">
            <centerbox
                orientation={Gtk.Orientation.VERTICAL}
                startWidget={
                    (
                        <box
                            class="metadata"
                            orientation={Gtk.Orientation.VERTICAL}
                            halign={Gtk.Align.START}
                            valign={Gtk.Align.CENTER}
                            hexpand
                        >
                            {mpris.TitleLabel(player)}
                            {mpris.ArtistLabel(player)}
                        </box>
                    ) as Gtk.Box
                }
            />

            <centerbox
                orientation={Gtk.Orientation.VERTICAL}
                centerWidget={mpris.PlayPauseButton({ player, colors })}
            />
        </box>
    ) as Gtk.Box;

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
    ) as Gtk.Box;

const PlayerBox = (
    player: Mpris.Player,
    colors: Accessor<mpris.Colors>,
    setColors: Setter<mpris.Colors>,
    overlay: PlayerGestureClass,
) => {
    const widget = mpris.CoverArt({
        player,
        colors,
        setColors,
        props: {
            class: `player ${player.identity}`,
            hexpand: true,

            startWidget: Top(player, overlay),
            centerWidget: Center(player, colors),
            endWidget: Bottom(player, colors),
        },
    });

    widget.visible = false;

    return widget;
};

export default () => {
    const content = PlayerGesture({
        setup: (self) => {
            const disposers = new Map<string, () => void>();

            const addPlayer = (player: Mpris.Player) => {
                if (!player || self.players.has(player.bus_name)) {
                    return;
                }

                // Get the one on top so we can move it up later
                const previousFirst = self.overlays.at(-1);

                // Make the new player
                const [colorsVar, setColorsVar] = createState({
                    imageAccent: '#6b4fa2',
                    buttonAccent: '#ecdcff',
                    buttonText: '#25005a',
                    hoverAccent: '#d4baff',
                });

                self.players.set(
                    player.bus_name,
                    createRoot((dispose) => {
                        disposers.set(player.bus_name, dispose);

                        return PlayerBox(player, colorsVar, setColorsVar, self);
                    }),
                );
                self.add_player(self.players.get(player.bus_name));

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

                const toDelete = self.players.get(
                    player.bus_name,
                ) as PlayerBoxClass;

                // Get the one on top so we can move it up later
                const previousFirst = self.overlays.at(-1);

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
                self.remove_player(toDelete);
                self.players.delete(player.bus_name);
                disposers.get(player.bus_name)?.();
                disposers.delete(player.bus_name);
            };

            const mpris = Mpris.get_default();

            mpris.connect('player-added', (_, player) => addPlayer(player));
            mpris.connect('player-closed', (_, player) => removePlayer(player));

            mpris.players.forEach(addPlayer);
        },
    });

    return (<box class="media-player">{content}</box>) as Gtk.Box;
};

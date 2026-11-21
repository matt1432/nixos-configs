import { property, register } from 'ags/gobject';
import { Gtk } from 'ags/gtk4';
import { timeout } from 'ags/time';
import Mpris from 'gi://AstalMpris';

import { setCss } from '../../lib/widgets';

const MAX_OFFSET = 200;
const OFFSCREEN = 500;
const ANIM_DURATION = 500;
const TRANSITION = `transition: margin ${ANIM_DURATION}ms ease,
                                opacity ${ANIM_DURATION}ms ease;`;

type PlayerBoxProps = Partial<
    Gtk.CenterBox.ConstructorProps & {
        bgStyle: string;
        player: Mpris.Player;
        setup: (self: PlayerBox) => void;
    }
>;

@register()
export class PlayerBox extends Gtk.CenterBox {
    @property(String) bgStyle: string = '';

    @property(Object) player: Mpris.Player =
        undefined as unknown as Mpris.Player;

    constructor({ setup, ...props }: PlayerBoxProps) {
        super(props as Partial<Gtk.CenterBox.ConstructorProps>);
        setup?.(this);
    }
}

/*
 * Gtk4's Gtk.Overlay can't reorder its overlays, so we keep our own
 * ordered list (bottom to top) and re-add the overlays when it changes.
 */
@register()
export class PlayerGesture extends Gtk.Overlay {
    private _widget: Gtk.Widget;
    private _gesture: Gtk.GestureDrag;
    private _overlays: PlayerBox[] = [];

    players = new Map();
    setup = false;
    dragging = false;

    get overlays(): PlayerBox[] {
        return [...this._overlays];
    }

    add_player(player: PlayerBox) {
        this._overlays.push(player);
        this.add_overlay(player);
    }

    remove_player(player: PlayerBox) {
        this._overlays = this._overlays.filter((p) => p !== player);
        this.remove_overlay(player);
    }

    private reorder_overlay(player: PlayerBox, index: number) {
        const others = this._overlays.filter((p) => p !== player);

        if (index < 0) {
            index = others.length + 1 + index;
        }

        others.splice(index, 0, player);

        if (others.every((p, i) => p === this._overlays[i])) {
            return;
        }

        this._overlays.forEach((p) => this.remove_overlay(p));
        this._overlays = others;
        this._overlays.forEach((p) => this.add_overlay(p));
    }

    includesWidget(playerW: PlayerBox) {
        return this.overlays.find((w) => w === playerW);
    }

    showTopOnly() {
        this.overlays.forEach((over) => {
            over.visible = over === this.overlays.at(-1);
        });
    }

    moveToTop(player: PlayerBox | undefined) {
        if (!player) {
            return;
        }

        player.visible = true;
        this.reorder_overlay(player, -1);
        timeout(ANIM_DURATION, () => {
            this.showTopOnly();
        });
    }

    dragUpdate() {
        this.overlays.forEach((over) => {
            over.visible = true;
        });

        // Don't allow gesture when only one player
        if (this.overlays.length <= 1) {
            return;
        }

        this.dragging = true;
        let offset = this._gesture.get_offset()[1];
        const playerBox = this.overlays.at(-1) as PlayerBox;

        if (!offset) {
            return;
        }

        // Slide right
        if (offset >= 0) {
            setCss(
                playerBox,
                `
                    margin-left:   ${offset}px;
                    margin-right: -${offset}px;
                    ${playerBox.bgStyle}
                `,
            );
        }

        // Slide left
        else {
            offset = Math.abs(offset);
            setCss(
                playerBox,
                `
                    margin-left: -${offset}px;
                    margin-right: ${offset}px;
                    ${playerBox.bgStyle}
                `,
            );
        }
    }

    dragEnd() {
        // Don't allow gesture when only one player
        if (this.overlays.length <= 1) {
            return;
        }

        this.dragging = false;
        const offset = this._gesture.get_offset()[1];

        const playerBox = this.overlays.at(-1) as PlayerBox;

        // If crosses threshold after letting go, slide away
        if (offset && Math.abs(offset) > MAX_OFFSET) {
            // Disable inputs during animation
            this._widget.sensitive = false;

            // Slide away right
            if (offset >= 0) {
                setCss(
                    playerBox,
                    `
                        ${TRANSITION}
                        margin-left:   ${OFFSCREEN}px;
                        margin-right: -${OFFSCREEN}px;
                        opacity: 0.7; ${playerBox.bgStyle}
                    `,
                );
            }

            // Slide away left
            else {
                setCss(
                    playerBox,
                    `
                        ${TRANSITION}
                        margin-left: -${OFFSCREEN}px;
                        margin-right: ${OFFSCREEN}px;
                        opacity: 0.7; ${playerBox.bgStyle}
                    `,
                );
            }

            timeout(ANIM_DURATION, () => {
                // Put the player in the back after anim
                this.reorder_overlay(playerBox, 0);
                // Recenter player
                setCss(playerBox, playerBox.bgStyle);

                this._widget.sensitive = true;

                this.showTopOnly();
            });
        }
        else {
            // Recenter with transition for animation
            setCss(playerBox, `${TRANSITION} ${playerBox.bgStyle}`);

            timeout(ANIM_DURATION, () => {
                this.showTopOnly();
            });
        }
    }

    constructor({
        setup = () => {},
        widget,
        ...props
    }: Partial<Gtk.Overlay.ConstructorProps> & {
        widget: Gtk.Widget;
        setup: (self: PlayerGesture) => void;
    }) {
        super(props);

        this._widget = widget;
        this._gesture = new Gtk.GestureDrag();
        this.add_controller(this._gesture);

        this._gesture.connect('drag-update', () => this.dragUpdate());
        this._gesture.connect('drag-end', () => this.dragEnd());

        setup(this);
    }
}

export default ({ setup }: { setup: (self: PlayerGesture) => void }) => {
    const widget = new Gtk.Box();

    // Have empty PlayerBox to define the size of the widget
    const emptyPlayer = (<PlayerBox class="player" />) as PlayerBox;

    const content = new PlayerGesture({
        setup,
        widget,
        child: emptyPlayer,
    });

    widget.append(content);

    return widget;
};

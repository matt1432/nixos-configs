import { property, register } from 'ags/gobject';
import { Astal, Gtk } from 'ags/gtk3';
import { timeout } from 'ags/time';
import Mpris from 'gi://AstalMpris';

import { getCssProvider, setCss } from '../../lib/widgets';

const MAX_OFFSET = 200;
const OFFSCREEN = 500;
const ANIM_DURATION = 500;
const TRANSITION = `transition: margin ${ANIM_DURATION}ms ease,
                                opacity ${ANIM_DURATION}ms ease;`;

export interface Gesture {
    attribute?: object;
    setup?: (self: PlayerGesture) => void;
    props?: Astal.Overlay.ConstructorProps;
}

@register()
export class PlayerBox extends Astal.CenterBox {
    @property(String) bgStyle: string = '';

    @property(Object) player: Mpris.Player =
        undefined as unknown as Mpris.Player;

    readonly cssProvider: Gtk.CssProvider;

    constructor(
        props: Partial<
            Omit<Astal.CenterBox.ConstructorProps, 'setup'> & {
                bgStyle?: string;
                player?: Mpris.Player;
                setup?: (self: PlayerBox) => void;
            }
        >,
    ) {
        super(props);
        this.cssProvider = getCssProvider(this);
    }
}

@register()
export class PlayerGesture extends Astal.Overlay {
    private _widget: Astal.EventBox;
    private _gesture: Gtk.GestureDrag;

    players = new Map();
    setup = false;
    dragging = false;

    set overlays(value) {
        super.overlays = value;
    }

    get overlays() {
        return super.overlays.filter((overlay) => overlay !== this.child);
    }

    includesWidget(playerW: PlayerBox) {
        return this.overlays.find((w) => w === playerW);
    }

    showTopOnly() {
        this.overlays.forEach((over) => {
            over.visible = over === this.overlays.at(-1);
        });
    }

    moveToTop(player: PlayerBox) {
        player.visible = true;
        this.reorder_overlay(player, -1);
        timeout(ANIM_DURATION, () => {
            this.showTopOnly();
        });
    }

    dragUpdate(realGesture: Gtk.GestureDrag) {
        if (realGesture) {
            this.overlays.forEach((over) => {
                over.visible = true;
            });
        }
        else {
            this.showTopOnly();
        }

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
                playerBox.cssProvider,
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
                playerBox.cssProvider,
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
                    playerBox.cssProvider,
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
                    playerBox.cssProvider,
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
                setCss(playerBox.cssProvider, playerBox.bgStyle);

                this._widget.sensitive = true;

                this.showTopOnly();
            });
        }
        else {
            // Recenter with transition for animation
            setCss(playerBox.cssProvider, `${TRANSITION} ${playerBox.bgStyle}`);

            timeout(ANIM_DURATION, () => {
                this.showTopOnly();
            });
        }
    }

    constructor({
        setup = () => {},
        widget,
        ...props
    }: Partial<Omit<Astal.Overlay.ConstructorProps, 'setup'>> & {
        widget: Astal.EventBox;
        setup: (self: PlayerGesture) => void;
    }) {
        super(props);
        setup(this);

        this._widget = widget;
        this._gesture = Gtk.GestureDrag.new(this);

        this._gesture.connect('drag-update', (realGesture) =>
            this.dragUpdate(realGesture),
        );
        this._gesture.connect('drag-end', () => this.dragEnd());
    }
}

export default ({ setup = () => {}, ...props }: Gesture) => {
    const widget = new Astal.EventBox();

    // Have empty PlayerBox to define the size of the widget
    const emptyPlayer = (<PlayerBox class="player" />) as PlayerBox;

    const content = (
        <PlayerGesture
            {...props}
            setup={setup}
            widget={widget}
            child={emptyPlayer}
        />
    ) as PlayerGesture;

    widget.add(content);

    return widget;
};

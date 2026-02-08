import { timeout } from 'astal';
import { property, register } from 'astal/gobject';
import { Gtk } from 'astal/gtk3';
import {
    CenterBox,
    CenterBoxProps,
    EventBox,
    Overlay,
    OverlayProps,
} from 'astal/gtk3/widget';
import Mpris from 'gi://AstalMpris';

const MAX_OFFSET = 200;
const OFFSCREEN = 500;
const ANIM_DURATION = 500;
const TRANSITION = `transition: margin ${ANIM_DURATION}ms ease,
                                opacity ${ANIM_DURATION}ms ease;`;

/* Types */
export interface Gesture {
    attribute?: object;
    setup?: (self: PlayerGesture) => void;
    props?: OverlayProps;
}

@register()
export class PlayerBox extends CenterBox {
    @property(String)
    declare bgStyle: string;

    @property(Object)
    declare player: Mpris.Player;

    constructor(
        props: Omit<CenterBoxProps, 'setup'> & {
            bgStyle?: string;
            player?: Mpris.Player;
            setup?: (self: PlayerBox) => void;
        },
    ) {
        super(props as CenterBoxProps);
    }
}

@register()
export class PlayerGesture extends Overlay {
    private _widget: EventBox;
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
            playerBox.css = `
                margin-left:   ${offset}px;
                margin-right: -${offset}px;
                ${playerBox.bgStyle}
            `;
        }

        // Slide left
        else {
            offset = Math.abs(offset);
            playerBox.css = `
                margin-left: -${offset}px;
                margin-right: ${offset}px;
                ${playerBox.bgStyle}
            `;
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
                playerBox.css = `
                    ${TRANSITION}
                    margin-left:   ${OFFSCREEN}px;
                    margin-right: -${OFFSCREEN}px;
                    opacity: 0.7; ${playerBox.bgStyle}
                `;
            }

            // Slide away left
            else {
                playerBox.css = `
                    ${TRANSITION}
                    margin-left: -${OFFSCREEN}px;
                    margin-right: ${OFFSCREEN}px;
                    opacity: 0.7; ${playerBox.bgStyle}
                `;
            }

            timeout(ANIM_DURATION, () => {
                // Put the player in the back after anim
                this.reorder_overlay(playerBox, 0);
                // Recenter player
                playerBox.css = playerBox.bgStyle;

                this._widget.sensitive = true;

                this.showTopOnly();
            });
        }
        else {
            // Recenter with transition for animation
            playerBox.css = `${TRANSITION} ${playerBox.bgStyle}`;

            timeout(ANIM_DURATION, () => {
                this.showTopOnly();
            });
        }
    }

    constructor({
        setup = () => {},
        widget,
        ...props
    }: Omit<OverlayProps, 'setup'> & {
        widget: EventBox;
        setup: (self: PlayerGesture) => void;
    }) {
        super(props);
        setup(this);

        this._widget = widget;
        this._gesture = Gtk.GestureDrag.new(this);

        this.hook(this._gesture, 'drag-update', (_, realGesture) =>
            this.dragUpdate(realGesture),
        );
        this.hook(this._gesture, 'drag-end', () => this.dragEnd());
    }
}

export default ({ setup = () => {}, ...props }: Gesture) => {
    const widget = new EventBox();

    // Have empty PlayerBox to define the size of the widget
    const emptyPlayer = new PlayerBox({
        className: 'player',
    });

    const content = new PlayerGesture({
        ...props,
        setup,
        widget,
        child: emptyPlayer,
    });

    widget.add(content);

    return widget;
};

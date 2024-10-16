import { Gdk, Gtk, Widget } from 'astal/gtk3';
import { register, property } from 'astal/gobject';
import { idle } from 'astal';

import AstalNotifd from 'gi://AstalNotifd?version=0.1';
const Notifications = AstalNotifd.get_default();

import AstalHyprland from 'gi://AstalHyprland?version=0.1';
const Hyprland = AstalHyprland.get_default();

import { HasNotifs } from './notification';
import { get_hyprland_monitor } from '../../lib';

/* Types */
interface Layer {
    address: string
    x: number
    y: number
    w: number
    h: number
    namespace: string
}
interface Levels {
    0?: Layer[] | null
    1?: Layer[] | null
    2?: Layer[] | null
    3?: Layer[] | null
}
interface Layers {
    levels: Levels
}
type LayerResult = Record<string, Layers>;
interface CursorPos {
    x: number
    y: number
}


const display = Gdk.Display.get_default();

const MAX_OFFSET = 200;
const OFFSCREEN = 300;
const ANIM_DURATION = 500;
const SLIDE_MIN_THRESHOLD = 10;
const TRANSITION = 'transition: margin 0.5s ease, opacity 0.5s ease;';
const MAX_LEFT = `
    margin-left: -${Number(MAX_OFFSET + OFFSCREEN)}px;
    margin-right: ${Number(MAX_OFFSET + OFFSCREEN)}px;
`;
const MAX_RIGHT = `
    margin-left:   ${Number(MAX_OFFSET + OFFSCREEN)}px;
    margin-right: -${Number(MAX_OFFSET + OFFSCREEN)}px;
`;

const slideLeft = `${TRANSITION} ${MAX_LEFT} opacity: 0;`;

const slideRight = `${TRANSITION} ${MAX_RIGHT} opacity: 0;`;

const defaultStyle = `${TRANSITION} margin: unset; opacity: 1;`;

type NotifGestureWrapperProps = Widget.BoxProps & {
    id: number
    slide_in_from?: 'Left' | 'Right'
};

@register()
export class NotifGestureWrapper extends Widget.EventBox {
    static popups = new Map<number, NotifGestureWrapper>();

    readonly id: number;

    readonly slide_in_from: 'Left' | 'Right';

    @property(Boolean)
    declare dragging: boolean;

    get hovered(): boolean {
        const layers = JSON.parse(Hyprland.message('j/layers')) as LayerResult;
        const cursorPos = JSON.parse(Hyprland.message('j/cursorpos')) as CursorPos;

        const window = this.get_window();

        if (window) {
            const monitor = display?.get_monitor_at_window(window);

            if (monitor) {
                const plugName = get_hyprland_monitor(monitor)?.name;
                const notifLayer = layers[plugName ?? '']?.levels['3']
                    ?.find((n) => n.namespace === 'notifications');

                if (notifLayer) {
                    const index = [...NotifGestureWrapper.popups.keys()]
                        .sort((a, b) => b - a)
                        .indexOf(this.id);

                    const popups = [...NotifGestureWrapper.popups.entries()]
                        .sort((a, b) => b[0] - a[0])
                        .map(([key, val]) => [key, val.get_allocated_height()]);

                    const thisY = notifLayer.y + popups
                        .map((v) => v[1])
                        .slice(0, index)
                        .reduce((prev, curr) => prev + curr, 0);

                    if (cursorPos.y >= thisY && cursorPos.y <= thisY + (popups[index][1] ?? 0)) {
                        if (cursorPos.x >= notifLayer.x && cursorPos.x <= notifLayer.x + notifLayer.w) {
                            return true;
                        }
                    }
                }
            }
        }

        return false;
    }

    public slideAway(side: 'Left' | 'Right', force = false) {
        ((this.get_child() as Widget.Revealer).get_child() as Widget.Box)
            .css = side === 'Left' ? slideLeft : slideRight;

        // Make it uninteractable
        this.sensitive = false;

        setTimeout(() => {
            (this.get_child() as Widget.Revealer).revealChild = false;

            setTimeout(() => {
                // Kill notif and update HasNotifs after anim is done
                if (force) {
                    Notifications.get_notification(this.id)?.dismiss();
                }
                HasNotifs.set(Notifications.get_notifications().length > 0);
                this.destroy();
            }, ANIM_DURATION);
        }, ANIM_DURATION - 100);
    }

    constructor({
        id,
        slide_in_from = 'Left',
        ...rest
    }: NotifGestureWrapperProps) {
        super();
        this.id = id;
        this.dragging = false;
        this.slide_in_from = slide_in_from;

        // OnClick
        this.connect('button-press-event', () => {
            if (!display) {
                return;
            }
            this.window.set_cursor(Gdk.Cursor.new_from_name(
                display,
                'grabbing',
            ));
        });

        // OnRelease
        this.connect('button-release-event', () => {
            if (!display) {
                return;
            }
            this.window.set_cursor(Gdk.Cursor.new_from_name(
                display,
                'grab',
            ));
        });

        // OnHover
        this.connect('enter-notify-event', () => {
            if (!display) {
                return;
            }
            this.window.set_cursor(Gdk.Cursor.new_from_name(
                display,
                'grab',
            ));
        });

        // OnHoverLost
        this.connect('leave-notify-event', () => {
            if (!display) {
                return;
            }
            this.window.set_cursor(Gdk.Cursor.new_from_name(
                display,
                'grab',
            ));
        });

        const gesture = Gtk.GestureDrag.new(this);

        this.add(
            <revealer
                transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}
                transitionDuration={500}
                revealChild={false}
            >
                <box
                    {...rest}
                    setup={(self) => {
                        self
                            // When dragging
                            .hook(gesture, 'drag-update', () => {
                                let offset = gesture.get_offset()[1];

                                if (!offset || offset === 0) {
                                    return;
                                }

                                // Slide right
                                if (offset > 0) {
                                    self.css = `
                                        opacity: 1; transition: none;
                                        margin-left:   ${offset}px;
                                        margin-right: -${offset}px;
                                    `;
                                }

                                // Slide left
                                else {
                                    offset = Math.abs(offset);
                                    self.css = `
                                        opacity: 1; transition: none;
                                        margin-right: ${offset}px;
                                        margin-left: -${offset}px;
                                    `;
                                }

                                // Put a threshold on if a click is actually dragging
                                this.dragging = Math.abs(offset) > SLIDE_MIN_THRESHOLD;

                                if (!display) {
                                    return;
                                }
                                this.window.set_cursor(Gdk.Cursor.new_from_name(
                                    display,
                                    'grabbing',
                                ));
                            })

                            // On drag end
                            .hook(gesture, 'drag-end', () => {
                                const offset = gesture.get_offset()[1];

                                if (!offset) {
                                    return;
                                }

                                // If crosses threshold after letting go, slide away
                                if (Math.abs(offset) > MAX_OFFSET) {
                                    if (offset > 0) {
                                        this.slideAway('Right');
                                    }
                                    else {
                                        this.slideAway('Left');
                                    }
                                }
                                else {
                                    self.css = defaultStyle;
                                    this.dragging = false;

                                    if (!display) {
                                        return;
                                    }
                                    this.window.set_cursor(Gdk.Cursor.new_from_name(
                                        display,
                                        'grab',
                                    ));
                                }
                            });

                        // Reverse of slideAway, so it started at squeeze, then we go to slide
                        self.css = this.slide_in_from === 'Left' ?
                            slideLeft :
                            slideRight;

                        idle(() => {
                            (self.get_parent() as Widget.Revealer).revealChild = true;

                            setTimeout(() => {
                                // Then we go to center
                                self.css = defaultStyle;
                            }, ANIM_DURATION);
                        });
                    }}
                />
            </revealer>,
        );
    }
}

export default (props: NotifGestureWrapperProps) => new NotifGestureWrapper(props);

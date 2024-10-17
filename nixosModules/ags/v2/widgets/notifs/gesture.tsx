import { Gdk, Gtk, Widget } from 'astal/gtk3';
import { register, signal } from 'astal/gobject';
import { idle, interval } from 'astal';

import AstalIO from 'gi://AstalIO?version=0.1';

import AstalNotifd from 'gi://AstalNotifd?version=0.1';
const Notifications = AstalNotifd.get_default();

import { hyprMessage } from '../../lib';

import { HasNotifs } from './notification';
import { get_hyprland_monitor } from '../../lib';

/* Types */
import { CursorPos, LayerResult } from '../../lib';


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
    popup_timer?: number
    setup_notif?: (self: NotifGestureWrapper) => void
};

@register()
export class NotifGestureWrapper extends Widget.EventBox {
    static popups = new Map<number, NotifGestureWrapper>();

    readonly id: number;

    readonly slide_in_from: 'Left' | 'Right';

    readonly is_popup: boolean;

    private timer_object: AstalIO.Time | undefined;

    public popup_timer: number;

    @signal(Number)
    declare timer_update: (popup_timer: number) => void;

    public dragging: boolean;

    private async get_hovered(): Promise<boolean> {
        try {
            const layers = JSON.parse(await hyprMessage('j/layers')) as LayerResult;
            const cursorPos = JSON.parse(await hyprMessage('j/cursorpos')) as CursorPos;

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
                            if (cursorPos.x >= notifLayer.x &&
                                cursorPos.x <= notifLayer.x + notifLayer.w) {
                                return true;
                            }
                        }
                    }
                }
            }
        }
        catch (e) {
            console.log(e);
        }

        return false;
    }

    public slideAway(side: 'Left' | 'Right') {
        if (!this.sensitive) {
            return;
        }

        ((this.get_child() as Widget.Revealer).get_child() as Widget.Box)
            .css = side === 'Left' ? slideLeft : slideRight;

        // Make it uninteractable
        this.sensitive = false;

        setTimeout(() => {
            (this.get_child() as Widget.Revealer).revealChild = false;

            setTimeout(() => {
                // Kill notif if specified
                if (!this.is_popup) {
                    Notifications.get_notification(this.id)?.dismiss();

                    // Update HasNotifs
                    HasNotifs.set(Notifications.get_notifications().length > 0);
                }
                else {
                    // Make sure we cleanup any references to this instance
                    NotifGestureWrapper.popups.delete(this.id);
                    this.timer_object?.cancel();
                }

                // Get rid of disappeared widget
                this.destroy();
            }, ANIM_DURATION);
        }, ANIM_DURATION - 100);
    }

    constructor({
        id,
        slide_in_from = 'Left',
        popup_timer = 0,
        setup_notif = () => { /**/ },
        ...rest
    }: NotifGestureWrapperProps) {
        super();

        this.id = id;
        this.slide_in_from = slide_in_from;
        this.dragging = false;

        this.popup_timer = popup_timer;
        this.is_popup = this.popup_timer !== 0;
        this.timer_update(this.popup_timer);

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

        // Handle timeout before sliding away if it is a popup
        if (this.popup_timer !== 0) {
            this.timer_object = interval(1000, async() => {
                if (!(await this.get_hovered())) {
                    if (this.popup_timer === 0) {
                        this.slideAway('Left');
                    }
                    else {
                        this.timer_update(--this.popup_timer);
                    }
                }
            });
        }

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

        setup_notif(this);
    }
}

export default (props: NotifGestureWrapperProps) => new NotifGestureWrapper(props);

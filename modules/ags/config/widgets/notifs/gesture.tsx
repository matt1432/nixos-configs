import { Gdk, Gtk, Widget } from 'astal/gtk3';
import { property, register } from 'astal/gobject';
import { idle, interval, timeout } from 'astal';

import AstalIO from 'gi://AstalIO';

import AstalNotifd from 'gi://AstalNotifd';

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
    public static popups = new Map<number, NotifGestureWrapper>();
    public static sliding_in = 0;
    public static on_sliding_in: (amount: number) => void;

    readonly id: number;
    readonly slide_in_from: 'Left' | 'Right';
    readonly is_popup: boolean;

    private timer_object: AstalIO.Time | undefined;

    @property(Number)
    declare popup_timer: number;

    @property(Boolean)
    declare dragging: boolean;

    private _sliding_away = false;

    private async get_hovered(): Promise<boolean> {
        const layers = JSON.parse(await hyprMessage('j/layers')) as LayerResult;
        const cursorPos = JSON.parse(await hyprMessage('j/cursorpos')) as CursorPos;

        const win = this.get_window();

        if (!win) {
            return false;
        }

        const monitor = display?.get_monitor_at_window(win);

        if (!monitor) {
            return false;
        }

        const plugName = get_hyprland_monitor(monitor)?.name;

        const notifLayer = layers[plugName ?? '']?.levels['3']
            ?.find((n) => n.namespace === 'notifications');

        if (!notifLayer) {
            return false;
        }

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

        if (cursorPos.y >= thisY && cursorPos.y <= thisY + (popups[index]?.at(1) ?? 0)) {
            if (cursorPos.x >= notifLayer.x &&
                cursorPos.x <= notifLayer.x + notifLayer.w) {
                return true;
            }
        }

        return false;
    }

    private setCursor(cursor: string) {
        if (!display) {
            return;
        }
        this.window.set_cursor(Gdk.Cursor.new_from_name(
            display,
            cursor,
        ));
    }

    public slideAway(side: 'Left' | 'Right', duplicate = false): void {
        if (!this.sensitive || this._sliding_away) {
            return;
        }

        // Make it uninteractable
        this.sensitive = false;
        this._sliding_away = true;

        let rev = this.get_child() as Widget.Revealer | null;

        if (!rev) {
            return;
        }

        const revChild = rev.get_child() as Widget.Box | null;

        if (!revChild) {
            return;
        }

        revChild.css = side === 'Left' ? slideLeft : slideRight;

        timeout(ANIM_DURATION - 100, () => {
            rev = this.get_child() as Widget.Revealer | null;

            if (!rev) {
                return;
            }

            rev.revealChild = false;

            timeout(ANIM_DURATION, () => {
                if (!duplicate) {
                    // Kill notif if specified
                    if (!this.is_popup) {
                        const notifications = AstalNotifd.get_default();

                        notifications.get_notification(this.id)?.dismiss();

                        // Update HasNotifs
                        HasNotifs.set(notifications.get_notifications().length > 0);
                    }
                    else {
                        // Make sure we cleanup any references to this instance
                        NotifGestureWrapper.popups.delete(this.id);
                    }
                }

                // Get rid of disappeared widget
                this.destroy();
            });
        });
    }

    constructor({
        id,
        slide_in_from = 'Left',
        popup_timer = 0,
        setup_notif = () => { /**/ },
        ...rest
    }: NotifGestureWrapperProps) {
        const notifications = AstalNotifd.get_default();

        super({
            on_button_press_event: () => {
                this.setCursor('grabbing');
            },

            // OnRelease
            on_button_release_event: () => {
                this.setCursor('grab');
            },

            // OnHover
            on_enter_notify_event: () => {
                this.setCursor('grab');
            },

            // OnHoverLost
            on_leave_notify_event: () => {
                this.setCursor('grab');
            },

            onDestroy: () => {
                this.timer_object?.cancel();
            },
        });

        this.id = id;
        this.slide_in_from = slide_in_from;
        this.dragging = false;

        this.popup_timer = popup_timer;
        this.is_popup = this.popup_timer !== 0;

        // Handle timeout before sliding away if it is a popup
        if (this.popup_timer !== 0) {
            this.timer_object = interval(1000, async() => {
                try {
                    if (!(await this.get_hovered())) {
                        if (this.popup_timer === 0) {
                            this.slideAway('Left');
                        }
                        else {
                            --this.popup_timer;
                        }
                    }
                }
                catch (_e) {
                    this.timer_object?.cancel();
                }
            });
        }

        this.hook(notifications, 'notified', (_, notifId) => {
            if (notifId === this.id) {
                this.slideAway(this.is_popup ? 'Left' : 'Right', true);
            }
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

                                this.setCursor('grabbing');
                            })

                            // On drag end
                            .hook(gesture, 'drag-end', () => {
                                const offset = gesture.get_offset()[1];

                                if (!offset) {
                                    return;
                                }

                                // If crosses threshold after letting go, slide away
                                if (Math.abs(offset) > MAX_OFFSET) {
                                    this.slideAway(offset > 0 ? 'Right' : 'Left');
                                }
                                else {
                                    self.css = defaultStyle;
                                    this.dragging = false;

                                    this.setCursor('grab');
                                }
                            });

                        if (this.is_popup) {
                            NotifGestureWrapper.on_sliding_in(++NotifGestureWrapper.sliding_in);
                        }

                        // Reverse of slideAway, so it started at squeeze, then we go to slide
                        self.css = this.slide_in_from === 'Left' ?
                            slideLeft :
                            slideRight;

                        idle(() => {
                            if (!notifications.get_notification(id)) {
                                return;
                            }

                            const rev = self?.get_parent() as Widget.Revealer | null;

                            if (!rev) {
                                return;
                            }

                            rev.revealChild = true;

                            timeout(ANIM_DURATION, () => {
                                if (!notifications.get_notification(id)) {
                                    return;
                                }

                                // Then we go to center
                                self.css = defaultStyle;

                                if (this.is_popup) {
                                    timeout(ANIM_DURATION, () => {
                                        NotifGestureWrapper.on_sliding_in(
                                            --NotifGestureWrapper.sliding_in,
                                        );
                                    });
                                }
                            });
                        });
                    }}
                />
            </revealer>,
        );

        setup_notif(this);
    }
}

export default NotifGestureWrapper;

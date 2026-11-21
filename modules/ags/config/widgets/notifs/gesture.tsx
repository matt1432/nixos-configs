import { property, register } from 'ags/gobject';
import { Gtk } from 'ags/gtk4';
import { idle, interval, timeout } from 'ags/time';
import AstalNotifd from 'gi://AstalNotifd';
import { createRoot, onCleanup } from 'gnim';

import { cursor, setCss } from '../../lib/widgets';
import { setHasNotifs } from './notification';

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

type NotifGestureWrapperProps = Omit<
    Partial<Gtk.Box.ConstructorProps>,
    'children'
> & {
    id: number;
    slide_in_from?: 'Left' | 'Right';
    popup_timer?: number;
    setup_notif?: (self: NotifGestureWrapper) => void;
    dispose_callback?: () => void;
    children: Gtk.Widget[];
};

@register()
export class NotifGestureWrapper extends Gtk.Box {
    dispose: (() => void) | null = null;

    public static popups = new Map<number, NotifGestureWrapper>();
    public static sliding_in = 0;
    public static on_sliding_in: (amount: number) => void;

    readonly id: number;
    readonly slide_in_from: 'Left' | 'Right';
    readonly is_popup: boolean;

    private timer_object: ReturnType<typeof interval> | undefined;

    @property(Number) popup_timer: number;

    @property(Boolean) dragging: boolean;

    private _sliding_away = false;
    private _hovered = false;

    private setCursor(name: string) {
        this.set_cursor(cursor(name));
    }

    public slideAway(side: 'Left' | 'Right', duplicate = false): void {
        if (!this.sensitive || this._sliding_away) {
            return;
        }

        // Make it uninteractable
        this.sensitive = false;
        this._sliding_away = true;

        let rev = this.get_first_child() as Gtk.Revealer | null;

        if (!rev) {
            return;
        }

        const revChild = rev.get_child() as Gtk.Box | null;

        if (!revChild) {
            return;
        }

        setCss(revChild, side === 'Left' ? slideLeft : slideRight);

        timeout(ANIM_DURATION - 100, () => {
            rev = this.get_first_child() as Gtk.Revealer | null;

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
                        setHasNotifs(
                            notifications.get_notifications().length > 0,
                        );
                    }
                    else {
                        // Make sure we cleanup any references to this instance
                        NotifGestureWrapper.popups.delete(this.id);
                    }
                }

                // Get rid of disappeared widget
                this.dispose?.();

                const root = this.get_root();

                (this.get_parent() as Gtk.Box | null)?.remove(this);

                // Gtk4 windows don't shrink by themselves
                if (root instanceof Gtk.Window) {
                    root.set_default_size(1, 1);
                }
            });
        });
    }

    constructor({
        id,
        slide_in_from = 'Left',
        popup_timer = 0,
        setup_notif = () => {},
        dispose_callback = () => {},
        children,
        ...rest
    }: NotifGestureWrapperProps) {
        super();

        this.id = id;
        this.slide_in_from = slide_in_from;
        this.dragging = false;

        this.popup_timer = popup_timer;
        this.is_popup = this.popup_timer !== 0;

        this.setCursor('grab');

        createRoot((dispose) => {
            this.dispose = dispose;

            const notifications = AstalNotifd.get_default();

            // Pause the popup timer while hovered
            const motion = new Gtk.EventControllerMotion();

            motion.connect('enter', () => {
                this._hovered = true;
            });
            motion.connect('leave', () => {
                this._hovered = false;
            });
            this.add_controller(motion);

            // Handle timeout before sliding away if it is a popup
            if (this.popup_timer !== 0) {
                this.timer_object = interval(1000, () => {
                    if (!this._hovered) {
                        if (this.popup_timer === 0) {
                            this.slideAway('Left');
                        }
                        else {
                            --this.popup_timer;
                        }
                    }
                });
            }

            const notifsConnections: number[] = [];

            notifsConnections.push(
                notifications.connect('notified', (_, notifId) => {
                    if (notifId === this.id) {
                        this.slideAway(this.is_popup ? 'Left' : 'Right', true);
                    }
                }),
            );

            const gesture = new Gtk.GestureDrag();

            this.add_controller(gesture);

            const content = (<box {...rest}>{children}</box>) as Gtk.Box;

            const rev = (
                <revealer
                    transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}
                    transitionDuration={500}
                    revealChild={false}
                >
                    {content}
                </revealer>
            ) as Gtk.Revealer;

            gesture.connect('drag-begin', () => {
                this.setCursor('grabbing');
            });

            // When dragging
            gesture.connect('drag-update', () => {
                let offset = gesture.get_offset()[1];

                if (!offset || offset === 0) {
                    return;
                }

                // Slide right
                if (offset > 0) {
                    setCss(
                        content,
                        `
                            opacity: 1; transition: none;
                            margin-left:   ${offset}px;
                            margin-right: -${offset}px;
                        `,
                    );
                }

                // Slide left
                else {
                    offset = Math.abs(offset);
                    setCss(
                        content,
                        `
                            opacity: 1; transition: none;
                            margin-right: ${offset}px;
                            margin-left: -${offset}px;
                        `,
                    );
                }

                // Put a threshold on if a click is actually dragging
                this.dragging = Math.abs(offset) > SLIDE_MIN_THRESHOLD;

                this.setCursor('grabbing');
            });

            // On drag end
            gesture.connect('drag-end', () => {
                const offset = gesture.get_offset()[1];

                this.setCursor('grab');

                if (!offset) {
                    return;
                }

                // If crosses threshold after letting go, slide away
                if (Math.abs(offset) > MAX_OFFSET) {
                    this.slideAway(offset > 0 ? 'Right' : 'Left');
                }
                else {
                    setCss(content, defaultStyle);
                    this.dragging = false;
                }
            });

            if (this.is_popup) {
                NotifGestureWrapper.on_sliding_in(
                    ++NotifGestureWrapper.sliding_in,
                );
            }

            // Reverse of slideAway, so it started at squeeze, then we go to slide
            setCss(
                content,
                this.slide_in_from === 'Left' ? slideLeft : slideRight,
            );

            idle(() => {
                if (!notifications.get_notification(id)) {
                    return;
                }

                rev.revealChild = true;

                timeout(ANIM_DURATION, () => {
                    if (!notifications.get_notification(id)) {
                        return;
                    }

                    // Then we go to center
                    setCss(content, defaultStyle);

                    if (this.is_popup) {
                        timeout(ANIM_DURATION, () => {
                            NotifGestureWrapper.on_sliding_in(
                                --NotifGestureWrapper.sliding_in,
                            );
                        });
                    }
                });
            });

            this.append(rev);

            setup_notif(this);

            onCleanup(() => {
                this.timer_object?.cancel();
                notifsConnections.forEach((connId) => {
                    notifications.disconnect(connId);
                });
                this.remove_controller(gesture);
                this.remove_controller(motion);
                dispose_callback();
            });
        });
    }
}

export default NotifGestureWrapper;

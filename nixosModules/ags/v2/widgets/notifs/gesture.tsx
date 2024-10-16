import { Gdk, Gtk, Widget } from 'astal/gtk3';
import { register, property } from 'astal/gobject';
import { idle } from 'astal';

import AstalNotifd from 'gi://AstalNotifd?version=0.1';
const Notifications = AstalNotifd.get_default();

import { HasNotifs } from './notification';


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
class NotifGestureWrapper extends Widget.EventBox {
    readonly id: number;

    readonly slide_in_from: 'Left' | 'Right';

    readonly slideAway: (side: 'Left' | 'Right') => void;

    @property(Boolean)
    declare hovered: boolean;

    @property(Boolean)
    declare dragging: boolean;

    constructor({
        id,
        slide_in_from = 'Left',
        ...rest
    }: NotifGestureWrapperProps) {
        super();
        this.id = id;
        this.dragging = false;
        this.hovered = false;
        this.slide_in_from = slide_in_from;

        this.slideAway = (side: 'Left' | 'Right', force = false) => {
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
        };

        this.connect('notify::dragging', () => {
            if (!this.hovered && this.dragging) {
                this.hovered = true;
            }
        });

        // OnClick
        this.connect('button-press-event', () => {
            if (!display) {
                return;
            }
            this.window.set_cursor(Gdk.Cursor.new_from_name(
                display,
                'grabbing',
            ));
            if (!this.hovered) {
                this.hovered = true;
            }
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
            if (!this.hovered) {
                this.hovered = true;
            }
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
            if (!this.hovered) {
                this.hovered = true;
            }
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

            if (this.hovered) {
                this.hovered = false;
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

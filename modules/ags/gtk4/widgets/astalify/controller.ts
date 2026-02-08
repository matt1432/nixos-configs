import { Gdk, Gtk } from 'astal/gtk4';

export interface EventController<Self extends Gtk.Widget> {
    onFocusEnter?: (self: Self) => void;
    onFocusLeave?: (self: Self) => void;

    onKeyPressed?: (
        self: Self,
        keyval: number,
        keycode: number,
        state: Gdk.ModifierType,
    ) => void;
    onKeyReleased?: (
        self: Self,
        keyval: number,
        keycode: number,
        state: Gdk.ModifierType,
    ) => void;
    onKeyModifier?: (self: Self, state: Gdk.ModifierType) => void;

    onLegacy?: (self: Self, event: Gdk.Event) => void;
    onButtonPressed?: (self: Self, state: Gdk.ButtonEvent) => void;
    onButtonReleased?: (self: Self, state: Gdk.ButtonEvent) => void;

    onHoverEnter?: (self: Self, x: number, y: number) => void;
    onHoverLeave?: (self: Self) => void;
    onMotion?: (self: Self, x: number, y: number) => void;

    onScroll?: (self: Self, dx: number, dy: number) => void;
    onScrollDecelerate?: (self: Self, vel_x: number, vel_y: number) => void;
}

export default <T>(
    widget: Gtk.Widget,
    {
        onFocusEnter,
        onFocusLeave,
        onKeyPressed,
        onKeyReleased,
        onKeyModifier,
        onLegacy,
        onButtonPressed,
        onButtonReleased,
        onHoverEnter,
        onHoverLeave,
        onMotion,
        onScroll,
        onScrollDecelerate,
        ...props
    }: EventController<Gtk.Widget> & T,
) => {
    if (onFocusEnter || onFocusLeave) {
        const focus = new Gtk.EventControllerFocus();

        widget.add_controller(focus);

        if (onFocusEnter) {
            focus.connect('focus-enter', () => onFocusEnter(widget));
        }

        if (onFocusLeave) {
            focus.connect('focus-leave', () => onFocusLeave(widget));
        }
    }

    if (onKeyPressed || onKeyReleased || onKeyModifier) {
        const key = new Gtk.EventControllerKey();

        widget.add_controller(key);

        if (onKeyPressed) {
            key.connect('key-pressed', (_, val, code, state) =>
                onKeyPressed(widget, val, code, state),
            );
        }

        if (onKeyReleased) {
            key.connect('key-released', (_, val, code, state) =>
                onKeyReleased(widget, val, code, state),
            );
        }

        if (onKeyModifier) {
            key.connect('modifiers', (_, state) =>
                onKeyModifier(widget, state),
            );
        }
    }

    if (onLegacy || onButtonPressed || onButtonReleased) {
        const legacy = new Gtk.EventControllerLegacy();

        widget.add_controller(legacy);

        legacy.connect('event', (_, event) => {
            if (event.get_event_type() === Gdk.EventType.BUTTON_PRESS) {
                onButtonPressed?.(widget, event as Gdk.ButtonEvent);
            }

            if (event.get_event_type() === Gdk.EventType.BUTTON_RELEASE) {
                onButtonReleased?.(widget, event as Gdk.ButtonEvent);
            }

            onLegacy?.(widget, event);
        });
    }

    if (onMotion || onHoverEnter || onHoverLeave) {
        const hover = new Gtk.EventControllerMotion();

        widget.add_controller(hover);

        if (onHoverEnter) {
            hover.connect('enter', (_, x, y) => onHoverEnter(widget, x, y));
        }

        if (onHoverLeave) {
            hover.connect('leave', () => onHoverLeave(widget));
        }

        if (onMotion) {
            hover.connect('motion', (_, x, y) => onMotion(widget, x, y));
        }
    }

    if (onScroll || onScrollDecelerate) {
        const scroll = new Gtk.EventControllerScroll();

        widget.add_controller(scroll);

        if (onScroll) {
            scroll.connect('scroll', (_, x, y) => onScroll(widget, x, y));
        }

        if (onScrollDecelerate) {
            scroll.connect('decelerate', (_, x, y) =>
                onScrollDecelerate(widget, x, y),
            );
        }
    }

    return props;
};

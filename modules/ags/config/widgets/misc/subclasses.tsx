import { getter, register, setter } from 'ags/gobject';
import { Astal, Gdk, Gtk } from 'ags/gtk3';
import { CCProps } from 'gnim';
import { intrinsicElements } from 'gnim/gtk3/jsx-runtime';

@register()
export class ToggleButton extends Gtk.ToggleButton {
    _cursor: string = 'default';

    @getter(String)
    get cursor() {
        return this._cursor;
    }

    @setter(String)
    set cursor(value: string) {
        const display = Gdk.Display.get_default();
        if (display) {
            // OnHover
            this.connect('enter-notify-event', () => {
                if (!display) {
                    return;
                }
                this.get_window()?.set_cursor(
                    Gdk.Cursor.new_from_name(display, value),
                );
            });

            // OnHoverLost
            this.connect('leave-notify-event', () => {
                if (!display) {
                    return;
                }
                this.get_window()?.set_cursor(null);
            });
        }
    }

    constructor(
        props: Partial<
            Gtk.ToggleButton.ConstructorProps & { cursor: string }
        > = {},
    ) {
        super(props);
    }
}

@register()
export class RadioButton extends Gtk.RadioButton {
    _cursor: string = 'default';

    @getter(String)
    get cursor() {
        return this._cursor;
    }

    @setter(String)
    set cursor(value: string) {
        const display = Gdk.Display.get_default();
        if (display) {
            // OnHover
            this.connect('enter-notify-event', () => {
                if (!display) {
                    return;
                }
                this.get_window()?.set_cursor(
                    Gdk.Cursor.new_from_name(display, value),
                );
            });

            // OnHoverLost
            this.connect('leave-notify-event', () => {
                if (!display) {
                    return;
                }
                this.get_window()?.set_cursor(null);
            });
        }
    }

    constructor(
        props: Partial<
            Gtk.RadioButton.ConstructorProps & { cursor: string }
        > = {},
    ) {
        super(props);
    }
}

@register()
export class ListBox extends Gtk.ListBox {
    override get_children() {
        return super.get_children() as Gtk.ListBoxRow[];
    }

    constructor(props: Partial<Gtk.ListBox.ConstructorProps> = {}) {
        super(props);
    }
}

@register()
export class ProgressBar extends Gtk.ProgressBar {
    constructor(props: Partial<Gtk.ProgressBar.ConstructorProps> = {}) {
        super(props);
    }
}

@register()
export class ComboBoxText extends Gtk.ComboBoxText {
    constructor(props: Partial<Gtk.ComboBoxText.ConstructorProps> = {}) {
        super(props);
    }
}

// Add Cursor to some intrinsicElements
type CursorProps<T extends Gtk.Widget.ConstructorProps> = T & {
    cursor: string;
};

@register()
class Button extends Astal.Button {
    _cursor: string = 'default';

    @getter(String)
    get cursor() {
        return this._cursor;
    }

    @setter(String)
    set cursor(value: string) {
        const display = Gdk.Display.get_default();
        if (display) {
            // OnHover
            this.connect('enter-notify-event', () => {
                if (!display) {
                    return;
                }
                this.get_window()?.set_cursor(
                    Gdk.Cursor.new_from_name(display, value),
                );
            });

            // OnHoverLost
            this.connect('leave-notify-event', () => {
                if (!display) {
                    return;
                }
                this.get_window()?.set_cursor(null);
            });
        }
    }

    constructor(props: Partial<CursorProps<Astal.Button.ConstructorProps>>) {
        super(props);
    }
}

intrinsicElements['cursor-button'] = Button;

@register()
class Slider extends Astal.Slider {
    _cursor: string = 'default';

    @getter(String)
    get cursor() {
        return this._cursor;
    }

    @setter(String)
    set cursor(value: string) {
        const display = Gdk.Display.get_default();
        if (display) {
            // OnHover
            this.connect('enter-notify-event', () => {
                if (!display) {
                    return;
                }
                this.get_window()?.set_cursor(
                    Gdk.Cursor.new_from_name(display, value),
                );
            });

            // OnHoverLost
            this.connect('leave-notify-event', () => {
                if (!display) {
                    return;
                }
                this.get_window()?.set_cursor(null);
            });
        }
    }

    constructor(props: Partial<CursorProps<Astal.Slider.ConstructorProps>>) {
        super(props);
    }
}

intrinsicElements['cursor-slider'] = Slider;

@register()
class MenuButton extends Gtk.MenuButton {
    _cursor: string = 'default';

    @getter(String)
    get cursor() {
        return this._cursor;
    }

    @setter(String)
    set cursor(value: string) {
        const display = Gdk.Display.get_default();
        if (display) {
            // OnHover
            this.connect('enter-notify-event', () => {
                if (!display) {
                    return;
                }
                this.get_window()?.set_cursor(
                    Gdk.Cursor.new_from_name(display, value),
                );
            });

            // OnHoverLost
            this.connect('leave-notify-event', () => {
                if (!display) {
                    return;
                }
                this.get_window()?.set_cursor(null);
            });
        }
    }

    constructor(props: Partial<CursorProps<Gtk.MenuButton.ConstructorProps>>) {
        super(props);
    }
}

intrinsicElements['cursor-menubutton'] = MenuButton;

@register()
class EventBox extends Astal.EventBox {
    _cursor: string = 'default';

    @getter(String)
    get cursor() {
        return this._cursor;
    }

    @setter(String)
    set cursor(value: string) {
        const display = Gdk.Display.get_default();
        if (display) {
            // OnHover
            this.connect('enter-notify-event', () => {
                if (!display) {
                    return;
                }
                this.get_window()?.set_cursor(
                    Gdk.Cursor.new_from_name(display, value),
                );
            });

            // OnHoverLost
            this.connect('leave-notify-event', () => {
                if (!display) {
                    return;
                }
                this.get_window()?.set_cursor(null);
            });
        }
    }

    constructor(props: Partial<CursorProps<Astal.EventBox.ConstructorProps>>) {
        super(props);
    }
}

intrinsicElements['cursor-eventbox'] = EventBox;

@register()
class Switch extends Gtk.Switch {
    _cursor: string = 'default';

    @getter(String)
    get cursor() {
        return this._cursor;
    }

    @setter(String)
    set cursor(value: string) {
        const display = Gdk.Display.get_default();
        if (display) {
            // OnHover
            this.connect('enter-notify-event', () => {
                if (!display) {
                    return;
                }
                this.get_window()?.set_cursor(
                    Gdk.Cursor.new_from_name(display, value),
                );
            });

            // OnHoverLost
            this.connect('leave-notify-event', () => {
                if (!display) {
                    return;
                }
                this.get_window()?.set_cursor(null);
            });
        }
    }

    constructor(props: Partial<CursorProps<Gtk.Switch.ConstructorProps>>) {
        super(props);
    }
}

intrinsicElements['cursor-switch'] = Switch;

declare global {
    // eslint-disable-next-line @typescript-eslint/no-namespace
    namespace JSX {
        interface IntrinsicElements {
            'cursor-button': CCProps<
                Button,
                Partial<CursorProps<Astal.Button.ConstructorProps>>
            >;
            'cursor-slider': CCProps<
                Slider,
                Partial<CursorProps<Astal.Slider.ConstructorProps>>
            >;
            'cursor-menubutton': CCProps<
                MenuButton,
                Partial<CursorProps<Gtk.MenuButton.ConstructorProps>>
            >;
            'cursor-eventbox': CCProps<
                EventBox,
                Partial<CursorProps<Astal.EventBox.ConstructorProps>>
            >;
            'cursor-switch': CCProps<
                Switch,
                Partial<CursorProps<Gtk.Switch.ConstructorProps>>
            >;
        }
    }
}

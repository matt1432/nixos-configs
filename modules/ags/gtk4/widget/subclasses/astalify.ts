/* eslint-disable @typescript-eslint/no-explicit-any */

import Gdk from 'gi://Gdk?version=4.0';
import GObject from 'gi://GObject';
import Gtk from 'gi://Gtk?version=4.0';

import Binding, { type Connectable, type Subscribable } from 'astal/binding';
import {
    hook,
    noImplicitDestroy,
    setChildren,
    construct,
} from '../../node_modules/astal/_astal';

export type BindableChild = Gtk.Widget | Binding<Gtk.Widget>;

export const filter = (children: any[]) => {
    return children.flat(Infinity).map((ch) => ch instanceof Gtk.Widget ?
        ch :
        new Gtk.Label({ visible: true, label: String(ch) }));
};

export const type = Symbol('child type');
const dummyBuilder = new Gtk.Builder();

interface EventController<Self extends Gtk.Widget> {
    onFocusEnter?: (self: Self) => void
    onFocusLeave?: (self: Self) => void

    onKeyPressed?: (self: Self, keyval: number, keycode: number, state: Gdk.ModifierType) => void
    onKeyReleased?: (self: Self, keyval: number, keycode: number, state: Gdk.ModifierType) => void
    onKeyModifier?: (self: Self, state: Gdk.ModifierType) => void

    onLegacy?: (self: Self, event: Gdk.Event) => void
    onButtonPressed?: (self: Self, state: Gdk.ButtonEvent) => void
    onButtonReleased?: (self: Self, state: Gdk.ButtonEvent) => void

    onHoverEnter?: (self: Self, x: number, y: number) => void
    onHoverLeave?: (self: Self) => void
    onMotion?: (self: Self, x: number, y: number) => void

    onScroll?: (self: Self, dx: number, dy: number) => void
    onScrollDecelerate?: (self: Self, vel_x: number, vel_y: number) => void
}

const setupControllers = <T>(widget: Gtk.Widget, {
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
}: EventController<Gtk.Widget> & T) => {
    if (onFocusEnter || onFocusLeave) {
        const focus = new Gtk.EventControllerFocus();

        widget.add_controller(focus);

        if (onFocusEnter) { focus.connect('focus-enter', () => onFocusEnter(widget)); }

        if (onFocusLeave) { focus.connect('focus-leave', () => onFocusLeave(widget)); }
    }

    if (onKeyPressed || onKeyReleased || onKeyModifier) {
        const key = new Gtk.EventControllerKey();

        widget.add_controller(key);

        if (onKeyPressed) {
            key.connect('key-pressed', (_, val, code, state) => onKeyPressed(widget, val, code, state));
        }

        if (onKeyReleased) {
            key.connect('key-released', (_, val, code, state) =>
                onKeyReleased(widget, val, code, state));
        }

        if (onKeyModifier) { key.connect('modifiers', (_, state) => onKeyModifier(widget, state)); }
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

        if (onHoverEnter) { hover.connect('enter', (_, x, y) => onHoverEnter(widget, x, y)); }

        if (onHoverLeave) { hover.connect('leave', () => onHoverLeave(widget)); }

        if (onMotion) { hover.connect('motion', (_, x, y) => onMotion(widget, x, y)); }
    }

    if (onScroll || onScrollDecelerate) {
        const scroll = new Gtk.EventControllerScroll();

        widget.add_controller(scroll);

        if (onScroll) { scroll.connect('scroll', (_, x, y) => onScroll(widget, x, y)); }

        if (onScrollDecelerate) {
            scroll.connect('decelerate', (_, x, y) => onScrollDecelerate(widget, x, y));
        }
    }

    return props;
};

export default <
    C extends new(...args: any[]) => Gtk.Widget,
>(cls: C, clsName = cls.name) => {
    class Widget extends cls {
        declare private _css: string | undefined;
        declare private _provider: Gtk.CssProvider | undefined;

        get css(): string | undefined {
            return this._css;
        }

        set css(value: string) {
            if (!this._provider) {
                this._provider = new Gtk.CssProvider();

                this.get_style_context().add_provider(
                    this._provider,
                    Gtk.STYLE_PROVIDER_PRIORITY_USER,
                );
            }

            this._css = value;
            this._provider.load_from_string(value);
        }

        declare private [type]: string;
        get type(): string { return this[type]; }
        set type(value: string) { this[type] = value; }

        get children(): Gtk.Widget[] { return this.getChildren(this); }
        set children(value: Gtk.Widget[]) { this.setChildren(this, value); }


        declare private [noImplicitDestroy]: boolean;
        get noImplicitDestroy(): boolean { return this[noImplicitDestroy]; }
        set noImplicitDestroy(value: boolean) { this[noImplicitDestroy] = value; }

        protected getChildren(widget: Gtk.Widget): Gtk.Widget[] {
            if ('get_child' in widget && typeof widget.get_child == 'function') {
                return widget.get_child() ? [widget.get_child()] : [];
            }

            const children: Gtk.Widget[] = [];
            let ch = widget.get_first_child();

            while (ch !== null) {
                children.push(ch);
                ch = ch.get_next_sibling();
            }

            return children;
        }

        protected setChildren(widget: Gtk.Widget, children: any[]) {
            children = children.flat(Infinity).map((ch) => ch instanceof Gtk.Widget ?
                ch :
                new Gtk.Label({ visible: true, label: String(ch) }));

            for (const child of children) {
                widget.vfunc_add_child(
                    dummyBuilder,
                    child,
                    type in widget ? widget[type] as string : null,
                );
            }
        }

        [setChildren](children: any[]) {
            const w = this as unknown as Widget;

            for (const child of (this.getChildren(w))) {
                if (child instanceof Gtk.Widget) {
                    child.unparent();
                    if (!children.includes(child) && noImplicitDestroy in this) { child.run_dispose(); }
                }
            }

            this.setChildren(w, children);
        }

        hook(
            object: Connectable,
            signal: string,
            callback: (self: this, ...args: any[]) => void,
        ): this;
        hook(
            object: Subscribable,
            callback: (self: this, ...args: any[]) => void,
        ): this;
        hook(
            object: Connectable | Subscribable,
            signalOrCallback: string | ((self: this, ...args: any[]) => void),
            callback?: (self: this, ...args: any[]) => void,
        ) {
            hook(this, object, signalOrCallback, callback);

            return this;
        }

        constructor(...params: any[]) {
            const props = params[0] || {};

            super('cssName' in props ? { cssName: props.cssName } : {});

            if ('cssName' in props) {
                delete props.cssName;
            }

            if (props.noImplicitDestroy) {
                this.noImplicitDestroy = true;
                delete props.noImplicitDestroy;
            }

            if (props.type) {
                this.type = props.type;
                delete props.type;
            }

            construct(this as any, setupControllers(this, props));
        }
    }

    GObject.registerClass({
        GTypeName: `RealClass_${clsName}`,
        Properties: {
            'css': GObject.ParamSpec.string(
                'css', '', '', GObject.ParamFlags.READWRITE, '',
            ),
            'type': GObject.ParamSpec.string(
                'type', '', '', GObject.ParamFlags.READWRITE, '',
            ),
            'no-implicit-destroy': GObject.ParamSpec.boolean(
                'no-implicit-destroy', '', '', GObject.ParamFlags.READWRITE, false,
            ),
        },
    }, Widget);

    return Widget;
};

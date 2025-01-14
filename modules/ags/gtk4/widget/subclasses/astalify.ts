// A mixin class must have a constructor with a single rest parameter of type 'any[]'
/* eslint "@typescript-eslint/no-explicit-any": ["error", { "ignoreRestArgs": true }] */

import { property, register } from 'astal';
import { Gdk, Gtk } from 'astal/gtk4';
import Binding, { type Connectable, type Subscribable } from 'astal/binding';

import {
    type EventController,
    hook,
    noImplicitDestroy,
    setChildren,
    construct,
} from './_astal';

import { type AstalifyProps, type BindableProps } from './_astal';
export { type AstalifyProps, type BindableProps };

export type BindableChild = Gtk.Widget | Binding<Gtk.Widget>;

export const type = Symbol('child type');
const dummyBuilder = new Gtk.Builder();

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

        if (onKeyModifier) {
            key.connect('modifiers', (_, state) => onKeyModifier(widget, state));
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
            scroll.connect('decelerate', (_, x, y) => onScrollDecelerate(widget, x, y));
        }
    }

    return props;
};

export default <
    C extends new (...props: any[]) => Gtk.Widget,
    ConstructorProps,
>(
    cls: C,
    clsName = cls.name,
) => {
    @register({ GTypeName: `RealClass_${clsName}` })
    class Widget extends cls {
        declare private _css: string | undefined;
        declare private _provider: Gtk.CssProvider | undefined;

        @property(String)
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

        @property(String)
        get type(): string { return this[type]; }

        set type(value: string) { this[type] = value; }


        @property(Object)
        get children(): Gtk.Widget[] { return this.getChildren(this); }

        set children(value: Gtk.Widget[]) { this.setChildren(this, value); }


        declare private [noImplicitDestroy]: boolean;

        @property(String)
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

        protected setChildren(widget: Gtk.Widget, children: Gtk.Widget[]) {
            for (const child of children) {
                widget.vfunc_add_child(
                    dummyBuilder,
                    child,
                    type in widget ? widget[type] as string : null,
                );
            }
        }

        [setChildren](children: Gtk.Widget[]) {
            for (const child of (this.getChildren(this))) {
                child?.unparent();

                if (!children.includes(child) && noImplicitDestroy in this) {
                    child.run_dispose();
                }
            }

            this.setChildren(this, children);
        }


        hook(
            object: Connectable,
            signal: string,
            callback: (self: this, ...args: unknown[]) => void,
        ): this;

        hook(
            object: Subscribable,
            callback: (self: this, ...args: unknown[]) => void,
        ): this;

        hook(
            object: Connectable | Subscribable,
            signalOrCallback: string | ((self: this, ...args: unknown[]) => void),
            callback?: (self: this, ...args: unknown[]) => void,
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

            construct(this, setupControllers(this, props));
        }
    }

    type Constructor<Instance, Props> = new (...args: Props[]) => Instance;

    type WidgetClass = Constructor<
        Widget & Gtk.Widget & InstanceType<C>,
        Partial<BindableProps<ConstructorProps>>
    >;

    return Widget as unknown as WidgetClass;
};

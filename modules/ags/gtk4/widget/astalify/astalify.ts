import { property, register } from 'astal';
import { Gtk, hook } from 'astal/gtk4';
import { type Connectable, type Subscribable } from 'astal/binding';

import construct from './construct';
import setupControllers from './controller';

import {
    type BindableProps,
    childType,
    type Cursor,
    dummyBuilder,
    type MixinParams,
    noImplicitDestroy,
    setChildren,
} from './generics';


export default <
    C extends new (...props: MixinParams) => Gtk.Widget,
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


        declare private [childType]: string;

        @property(String)
        get type(): string { return this[childType]; }

        set type(value: string) { this[childType] = value; }


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
                    childType in widget ? widget[childType] as string : null,
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


        private _cursorName: Cursor = 'default';

        @property(String)
        get cursorName(): Cursor {
            return this._cursorName;
        }

        set cursorName(val: Cursor) {
            this._cursorName = val;
            this.set_cursor_from_name(val);
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


        constructor(...params: MixinParams) {
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

    // override the parameters of the `super` constructor
    return Widget as unknown as WidgetClass;
};

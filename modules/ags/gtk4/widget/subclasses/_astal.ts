import { execAsync, Variable } from 'astal';
import { type Gdk, type Gtk, type ConstructProps } from 'astal/gtk4';
import { Binding, type Connectable, kebabify, snakeify, type Subscribable } from 'astal/binding';

export interface EventController<Self extends Gtk.Widget> {
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

export type BindableProps<T> = {
    [K in keyof T]: Binding<T[K]> | T[K];
};

export interface AstalifyProps {
    css: string
    child: Gtk.Widget
    children: Gtk.Widget[]
}

export const noImplicitDestroy = Symbol('no no implicit destroy');
export const setChildren = Symbol('children setter method');

const mergeBindings = <Value = unknown>(
    array: (Value | Binding<Value> | Binding<Value[]>)[],
): Value[] | Binding<Value[]> => {
    const getValues = (args: Value[]) => {
        let i = 0;

        return array.map((value) => value instanceof Binding ?
            args[i++] :
            value);
    };

    const bindings = array.filter((i) => i instanceof Binding);

    if (bindings.length === 0) {
        return array as Value[];
    }

    if (bindings.length === 1) {
        return (bindings[0] as Binding<Value[]>).as(getValues);
    }

    return Variable.derive(bindings, getValues)();
};

export const hook = <Widget extends Connectable>(
    widget: Widget,
    object: Connectable | Subscribable,
    signalOrCallback: string | ((self: Widget, ...args: unknown[]) => void),
    callback?: (self: Widget, ...args: unknown[]) => void,
) => {
    if (typeof object.connect === 'function' && callback) {
        const id = object.connect(signalOrCallback, (_: unknown, ...args: unknown[]) => {
            callback(widget, ...args);
        });

        widget.connect('destroy', () => {
            (object.disconnect as Connectable['disconnect'])(id);
        });
    }
    else if (typeof object.subscribe === 'function' && typeof signalOrCallback === 'function') {
        const unsub = object.subscribe((...args: unknown[]) => {
            signalOrCallback(widget, ...args);
        });

        widget.connect('destroy', unsub);
    }
};

export const construct = <
    Self extends InstanceType<typeof Gtk.Widget> & {
        [setChildren]: (children: Gtk.Widget[]) => void
    },
    Props extends Gtk.Widget.ConstructorProps,
>(
    widget: Self,
    props: Omit<
        ConstructProps<Self, Props> & Partial<BindableProps<AstalifyProps>>,
        keyof EventController<Self>
    >,
) => {
    type Key = keyof typeof props;
    const keys = Object.keys(props) as Key[];
    const entries = Object.entries(props) as [Key, unknown][];

    const setProp = (prop: Key, value: Self[keyof Self]) => {
        try {
            const setter = `set_${snakeify(prop.toString())}` as keyof Self;

            if (typeof widget[setter] === 'function') {
                return widget[setter](value);
            }

            return (widget[prop as keyof Self] = value);
        }
        catch (error) {
            console.error(`could not set property "${prop.toString()}" on ${widget}:`, error);
        }
    };

    const children = props.children ?
        props.children instanceof Binding ?
            [props.children] as (Binding<Gtk.Widget[]> | Binding<Gtk.Widget> | Gtk.Widget)[] :
            props.children as Gtk.Widget[] :
        [];

    if (props.child) {
        children.unshift(props.child);
    }

    // remove undefined values
    for (const [key, value] of entries) {
        if (typeof value === 'undefined') {
            delete props[key];
        }
    }

    // collect bindings
    const bindings: [Key, Binding<unknown>][] = [];

    for (const key of keys) {
        if (props[key] instanceof Binding) {
            bindings.push([key, props[key]]);
            delete props[key];
        }
    }

    // collect signal handlers
    const onHandlers: [string, string | (() => void)][] = [];

    for (const key of keys) {
        if (key.toString().startsWith('on')) {
            const sig = kebabify(key.toString()).split('-').slice(1).join('-');

            onHandlers.push([sig, props[key] as string | (() => void)]);
            delete props[key];
        }
    }

    // set children
    const mergedChildren = mergeBindings<Gtk.Widget>(children.flat(Infinity));

    if (mergedChildren instanceof Binding) {
        widget[setChildren](mergedChildren.get());

        widget.connect('destroy', mergedChildren.subscribe((v) => {
            widget[setChildren](v);
        }));
    }
    else if (mergedChildren.length > 0) {
        widget[setChildren](mergedChildren);
    }

    // setup signal handlers
    for (const [signal, callback] of onHandlers) {
        const sig = signal.startsWith('notify') ?
            signal.replace('-', '::') :
            signal;

        if (typeof callback === 'function') {
            widget.connect(sig, callback);
        }
        else {
            widget.connect(sig, () => execAsync(callback)
                .then(print).catch(console.error));
        }
    }

    // setup bindings handlers
    for (const [prop, binding] of bindings) {
        if (prop === 'child' || prop === 'children') {
            widget.connect('destroy', (binding as Binding<Gtk.Widget[]>).subscribe((v: Gtk.Widget[]) => {
                widget[setChildren](v);
            }));
        }
        widget.connect('destroy', binding.subscribe((v: unknown) => {
            setProp(prop, v as Self[keyof Self]);
        }));
        setProp(prop, binding.get() as Self[keyof Self]);
    }

    // filter undefined values
    for (const [key, value] of entries) {
        if (typeof value === 'undefined') {
            delete props[key];
        }
    }

    Object.assign(widget, props);
    props.setup?.(widget);

    return widget;
};

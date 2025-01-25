import { execAsync } from 'astal';
import { type Gtk, type ConstructProps } from 'astal/gtk4';
import { Binding, kebabify, snakeify } from 'astal/binding';

import { mergeBindings } from './bindings';
import { type EventController } from './controller';
import { type AstalifyProps, type BindableProps, type GenericWidget, setChildren } from './generics';


export default <
    Self extends GenericWidget,
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

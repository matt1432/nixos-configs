/* eslint-disable @typescript-eslint/no-explicit-any */
import { execAsync, Variable } from 'astal';
import Binding, { Connectable, kebabify, snakeify, Subscribable } from 'astal/binding';

export const noImplicitDestroy = Symbol('no no implicit destroy');
export const setChildren = Symbol('children setter method');

const mergeBindings = (array: any[]) => {
    const getValues = (...args: any[]) => {
        let i = 0;

        return array.map((value) => value instanceof Binding ?
            args[i++] :
            value);
    };

    const bindings = array.filter((i) => i instanceof Binding);

    if (bindings.length === 0) { return array; }

    if (bindings.length === 1) { return bindings[0].as(getValues); }

    return Variable.derive(bindings, getValues)();
};

const setProp = (obj: any, prop: string, value: any) => {
    try {
        const setter = `set_${snakeify(prop)}`;

        if (typeof obj[setter] === 'function') { return obj[setter](value); }

        return (obj[prop] = value);
    }
    catch (error) {
        console.error(`could not set property "${prop}" on ${obj}:`, error);
    }
};

export const hook = <Widget extends Connectable>(
    widget: Widget,
    object: Connectable | Subscribable,
    signalOrCallback: string | ((self: Widget, ...args: any[]) => void),
    callback?: (self: Widget, ...args: any[]) => void,
) => {
    if (typeof object.connect === 'function' && callback) {
        const id = object.connect(signalOrCallback, (_: any, ...args: unknown[]) => {
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

export const construct = <Widget extends Connectable & {
    [setChildren]: (children: any[]) => void
}>(widget: Widget, config: any) => {
    // eslint-disable-next-line prefer-const
    let { setup, child, children = [], ...props } = config;

    if (children instanceof Binding) {
        children = [children];
    }

    if (child) {
        children.unshift(child);
    }

    // remove undefined values
    for (const [key, value] of Object.entries(props)) {
        if (typeof value === 'undefined') {
            delete props[key];
        }
    }

    // collect bindings
    const bindings: [string, Binding<any>][] = Object
        .keys(props)
        .reduce((acc: any, prop) => {
            if (props[prop] instanceof Binding) {
                const binding = props[prop];

                delete props[prop];

                return [...acc, [prop, binding]];
            }

            return acc;
        }, []);

    // collect signal handlers
    const onHandlers: [string, string | (() => unknown)][] = Object
        .keys(props)
        .reduce((acc: any, key) => {
            if (key.startsWith('on')) {
                const sig = kebabify(key).split('-').slice(1).join('-');
                const handler = props[key];

                delete props[key];

                return [...acc, [sig, handler]];
            }

            return acc;
        }, []);

    // set children
    const mergedChildren = mergeBindings(children.flat(Infinity));

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
            widget.connect('destroy', binding.subscribe((v: any) => {
                widget[setChildren](v);
            }));
        }
        widget.connect('destroy', binding.subscribe((v: any) => {
            setProp(widget, prop, v);
        }));
        setProp(widget, prop, binding.get());
    }

    // filter undefined values
    for (const [key, value] of Object.entries(props)) {
        if (typeof value === 'undefined') {
            delete props[key];
        }
    }

    Object.assign(widget, props);
    setup?.(widget);

    return widget;
};

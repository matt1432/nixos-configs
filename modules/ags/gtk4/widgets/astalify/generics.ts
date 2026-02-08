import { Binding } from 'astal/binding';
import { Gtk } from 'astal/gtk4';

import { EventController } from './controller';

// A mixin class must have a constructor with a single rest parameter of type 'any[]'
// eslint-disable-next-line "@typescript-eslint/no-explicit-any"
export type MixinParams = any[];

export type BindableChild = Gtk.Widget | Binding<Gtk.Widget>;

export type BindableProps<T> = {
    [K in keyof T]: Binding<T[K]> | T[K];
};

export const noImplicitDestroy = Symbol('no no implicit destroy');
export const setChildren = Symbol('children setter method');
export const childType = Symbol('child type');

export const dummyBuilder = new Gtk.Builder();

export type GenericWidget = InstanceType<typeof Gtk.Widget> & {
    [setChildren]: (children: Gtk.Widget[]) => void;
};

export interface AstalifyProps {
    css: string;
    child: Gtk.Widget;
    children: Gtk.Widget[];
    cursorName: Cursor;
}

type SigHandler<
    W extends InstanceType<typeof Gtk.Widget>,
    Args extends unknown[],
> = ((self: W, ...args: Args) => unknown) | string | string[];

export type ConstructProps<
    Self extends InstanceType<typeof Gtk.Widget>,
    Props extends Gtk.Widget.ConstructorProps,
    Signals extends Record<`on${string}`, unknown[]> = Record<
        `on${string}`,
        unknown[]
    >,
> = Partial<{
    // @ts-expect-error can't assign to unknown, but it works as expected though
    [S in keyof Signals]: SigHandler<Self, Signals[S]>;
}> &
    Partial<Record<`on${string}`, SigHandler<Self, unknown[]>>> &
    Partial<BindableProps<Omit<Props, 'cssName' | 'css_name' | 'cursor'>>> & {
        noImplicitDestroy?: true;
        type?: string;
        cssName?: string;
    } & EventController<Self> & {
        onDestroy?: (self: Self) => unknown;
        setup?: (self: Self) => void;
    };

export type Cursor =
    | 'default'
    | 'help'
    | 'pointer'
    | 'context-menu'
    | 'progress'
    | 'wait'
    | 'cell'
    | 'crosshair'
    | 'text'
    | 'vertical-text'
    | 'alias'
    | 'copy'
    | 'no-drop'
    | 'move'
    | 'not-allowed'
    | 'grab'
    | 'grabbing'
    | 'all-scroll'
    | 'col-resize'
    | 'row-resize'
    | 'n-resize'
    | 'e-resize'
    | 's-resize'
    | 'w-resize'
    | 'ne-resize'
    | 'nw-resize'
    | 'sw-resize'
    | 'se-resize'
    | 'ew-resize'
    | 'ns-resize'
    | 'nesw-resize'
    | 'nwse-resize'
    | 'zoom-in'
    | 'zoom-out';

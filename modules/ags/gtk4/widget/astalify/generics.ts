import { Gtk } from 'astal/gtk4';
import { Binding } from 'astal/binding';

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
    [setChildren]: (children: Gtk.Widget[]) => void
};

export interface AstalifyProps {
    css: string
    child: Gtk.Widget
    children: Gtk.Widget[]
    cursorName: Cursor
}

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

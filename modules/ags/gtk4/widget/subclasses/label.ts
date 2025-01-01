/* eslint-disable @typescript-eslint/no-explicit-any */

import { register } from 'astal';
import { Gtk, type ConstructProps } from 'astal/gtk4';

import astalify from './astalify';


export type LabelProps = ConstructProps<
    Label,
    Gtk.Label.ConstructorProps & { css: string }
>;

@register({ GTypeName: 'Label' })
export class Label extends astalify(Gtk.Label) {
    constructor(props?: LabelProps) { super(props as any); }

    getChildren() { return []; }

    setChildren(self: Label, children: any[]) { self.label = String(children); }
}

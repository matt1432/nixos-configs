import { register } from 'astal';
import { Gtk, type ConstructProps } from 'astal/gtk4';

import astalify from './astalify';


export type LabelProps = ConstructProps<
    Label,
    Gtk.Label.ConstructorProps & { css: string }
>;

@register({ GTypeName: 'Label' })
export class Label extends astalify(Gtk.Label) {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    constructor(props?: LabelProps) { super(props as any); }

    getChildren() { return []; }
}

import { register } from 'astal';
import { Gtk, type ConstructProps } from 'astal/gtk4';

import astalify from './astalify';


export type RevealerProps = ConstructProps<
    Revealer,
    Gtk.Revealer.ConstructorProps & { css: string }
>;

@register({ GTypeName: 'Revealer' })
export class Revealer extends astalify(Gtk.Revealer) {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    constructor(props?: RevealerProps) { super(props as any); }
}

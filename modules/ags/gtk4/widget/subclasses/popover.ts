import { register } from 'astal';
import { Gtk, type ConstructProps } from 'astal/gtk4';

import astalify from './astalify';


export type PopoverProps = ConstructProps<
    Popover,
    Gtk.Popover.ConstructorProps & { css: string }
>;

@register({ GTypeName: 'Popover' })
export class Popover extends astalify(Gtk.Popover) {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    constructor(props?: PopoverProps) { super(props as any); }
}

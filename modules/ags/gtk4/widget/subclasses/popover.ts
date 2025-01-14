import { register } from 'astal';
import { Gtk, type ConstructProps } from 'astal/gtk4';

import astalify, { type AstalifyProps } from '../astalify';


export type PopoverProps = ConstructProps<
    PopoverClass,
    Gtk.Popover.ConstructorProps & AstalifyProps
>;

@register({ GTypeName: 'Popover' })
export class PopoverClass extends astalify(Gtk.Popover) {
    constructor({ cssName = 'popover', ...props }: PopoverProps = {}) {
        super({ cssName, ...props });
    }
}

export const Popover = (props?: PopoverProps) => new PopoverClass(props);

import { register } from 'astal';
import { Gtk } from 'astal/gtk4';

import astalify, { type AstalifyProps, type ConstructProps } from '../astalify';


export type RevealerProps = ConstructProps<
    RevealerClass,
    Gtk.Revealer.ConstructorProps & AstalifyProps
>;

@register({ GTypeName: 'Revealer' })
export class RevealerClass extends astalify(Gtk.Revealer) {
    constructor({ cssName = 'revealer', ...props }: RevealerProps = {}) {
        super({ cssName, ...props });
    }
}

export const Revealer = (props?: RevealerProps) => new RevealerClass(props);

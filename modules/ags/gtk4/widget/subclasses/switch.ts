import { register } from 'astal';
import { Gtk, type ConstructProps } from 'astal/gtk4';

import astalify, { type AstalifyProps } from '../astalify';


export type SwitchProps = ConstructProps<
    SwitchClass,
    Gtk.Switch.ConstructorProps & AstalifyProps
>;

@register({ GTypeName: 'Switch' })
export class SwitchClass extends astalify(Gtk.Switch) {
    constructor({ cssName = 'switch', ...props }: SwitchProps = {}) {
        super({ cssName, ...props });
    }

    getChildren() { return []; }
}

export const Switch = (props?: SwitchProps) => new SwitchClass(props);

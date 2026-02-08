import { register } from 'astal';
import { Gtk } from 'astal/gtk4';

import astalify, { type AstalifyProps, type ConstructProps } from '../astalify';

export type LabelProps = ConstructProps<
    LabelClass,
    Gtk.Label.ConstructorProps & AstalifyProps
>;

@register({ GTypeName: 'Label' })
export class LabelClass extends astalify(Gtk.Label) {
    constructor({ cssName = 'label', ...props }: LabelProps = {}) {
        super({ cssName, ...props });
    }

    getChildren() {
        return [];
    }
}

export const Label = (props?: LabelProps) => new LabelClass(props);

import { register } from 'astal';
import { Gtk, type ConstructProps } from 'astal/gtk4';

import astalify, { type AstalifyProps } from './astalify';


export type LabelProps = ConstructProps<
    LabelClass,
    Gtk.Label.ConstructorProps & AstalifyProps
>;

@register({ GTypeName: 'Label' })
export class LabelClass extends astalify(Gtk.Label) {
    constructor({ cssName = 'label', ...props }: LabelProps = {}) {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        super({ cssName, ...props as any });
    }

    getChildren() { return []; }
}

export const Label = (props?: LabelProps) => new LabelClass(props);

import { register } from 'astal';
import { Astal, Gtk } from 'astal/gtk4';

import astalify, { type AstalifyProps, type ConstructProps } from '../astalify';

export type BoxProps = ConstructProps<
    BoxClass,
    Astal.Box.ConstructorProps & AstalifyProps
>;

@register({ GTypeName: 'Box' })
export class BoxClass extends astalify(Astal.Box) {
    constructor({ cssName = 'box', ...props }: BoxProps = {}) {
        super({ cssName, ...props });
    }

    getChildren(self: BoxClass) {
        return self.get_children();
    }

    setChildren(self: BoxClass, children: Gtk.Widget[]) {
        return self.set_children(children);
    }
}

export const Box = (props?: BoxProps) => new BoxClass(props);

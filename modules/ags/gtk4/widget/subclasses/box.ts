import { register } from 'astal';
import { Astal, type ConstructProps, Gtk } from 'astal/gtk4';

import astalify from './astalify';


export type BoxProps = ConstructProps<
    Box,
    Astal.Box.ConstructorProps & { css: string }
>;

@register({ GTypeName: 'Box' })
export class Box extends astalify(Astal.Box) {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    constructor(props?: BoxProps) { super(props as any); }

    getChildren(self: Box) {
        return self.get_children();
    }

    setChildren(self: Box, children: Gtk.Widget[]) {
        return self.set_children(children);
    }
}

/* eslint-disable @typescript-eslint/no-explicit-any */

import { register } from 'astal';
import { Astal, type ConstructProps } from 'astal/gtk4';

import astalify, { filter } from './astalify';


export type BoxProps = ConstructProps<
    Box,
    Astal.Box.ConstructorProps & { css: string }
>;

@register({ GTypeName: 'Box' })
export class Box extends astalify(Astal.Box) {
    constructor(props?: BoxProps) { super(props as any); }

    getChildren(self: Box) {
        return self.get_children();
    }

    setChildren(self: Box, children: any[]) {
        return self.set_children(filter(children));
    }
}

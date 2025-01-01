/* eslint-disable @typescript-eslint/no-explicit-any */

import { register } from 'astal';
import { Gtk, type ConstructProps } from 'astal/gtk4';

import astalify, { filter } from './astalify';


export type StackProps = ConstructProps<
    Stack,
    Gtk.Stack.ConstructorProps & { css: string }
>;

@register({ GTypeName: 'Stack' })
export class Stack extends astalify(Gtk.Stack) {
    constructor(props?: StackProps) { super(props as any); }

    setChildren(self: Stack, children: any[]) {
        for (const child of filter(children)) {
            if (child.name !== '' && child.name !== null) {
                self.add_named(child, child.name);
            }
            else {
                self.add_child(child);
            }
        }
    }
}

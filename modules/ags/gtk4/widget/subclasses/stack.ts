import { register } from 'astal';
import { Gtk, type ConstructProps } from 'astal/gtk4';

import astalify from './astalify';


export type StackProps = ConstructProps<
    Stack,
    Gtk.Stack.ConstructorProps & { css: string }
>;

@register({ GTypeName: 'Stack' })
export class Stack extends astalify(Gtk.Stack) {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    constructor(props?: StackProps) { super(props as any); }

    setChildren(self: Stack, children: Gtk.Widget[]) {
        for (const child of children) {
            if (child.name !== '' && child.name !== null) {
                self.add_named(child, child.name);
            }
            else {
                self.add_child(child);
            }
        }
    }
}

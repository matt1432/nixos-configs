import { register } from 'astal';
import { Gtk, type ConstructProps } from 'astal/gtk4';

import astalify, { type AstalifyProps } from './astalify';


export type StackProps = ConstructProps<
    StackClass,
    Gtk.Stack.ConstructorProps & AstalifyProps
>;

@register({ GTypeName: 'Stack' })
export class StackClass extends astalify(Gtk.Stack) {
    constructor({ cssName = 'stack', ...props }: StackProps = {}) {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        super({ cssName, ...props as any });
    }

    setChildren(self: StackClass, children: Gtk.Widget[]) {
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

export const Stack = (props?: StackProps) => new StackClass(props);

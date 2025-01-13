import { register } from 'astal';
import { Gtk, type ConstructProps } from 'astal/gtk4';

import astalify, { type, type AstalifyProps } from './astalify';


export type OverlayProps = ConstructProps<
    OverlayClass,
    Gtk.Overlay.ConstructorProps & AstalifyProps
>;

@register({ GTypeName: 'Overlay' })
export class OverlayClass extends astalify(Gtk.Overlay) {
    constructor({ cssName = 'overlay', ...props }: OverlayProps = {}) {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        super({ cssName, ...props as any });
    }

    getChildren(self: OverlayClass) {
        const children: Gtk.Widget[] = [];
        let ch = self.get_first_child();

        while (ch !== null) {
            children.push(ch);
            ch = ch.get_next_sibling();
        }

        return children.filter((child) => child !== self.child);
    }

    setChildren(self: OverlayClass, children: Gtk.Widget[]) {
        for (const child of children) {
            const types = type in child ?
                (child[type] as string).split(/\s+/) :
                [];

            if (types.includes('overlay')) {
                self.add_overlay(child);
            }
            else {
                self.set_child(child);
            }

            self.set_measure_overlay(child, types.includes('measure'));
            self.set_clip_overlay(child, types.includes('clip'));
        }
    }
}

export const Overlay = (props?: OverlayProps) => new OverlayClass(props);

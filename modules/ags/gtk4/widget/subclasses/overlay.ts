import { register } from 'astal';
import { Gtk, type ConstructProps } from 'astal/gtk4';

import astalify, { type } from './astalify';


export type OverlayProps = ConstructProps<
    Overlay,
    Gtk.Overlay.ConstructorProps & { css: string }
>;

@register({ GTypeName: 'Overlay' })
export class Overlay extends astalify(Gtk.Overlay) {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    constructor(props?: OverlayProps) { super(props as any); }

    getChildren(self: Overlay) {
        const children: Gtk.Widget[] = [];
        let ch = self.get_first_child();

        while (ch !== null) {
            children.push(ch);
            ch = ch.get_next_sibling();
        }

        return children.filter((child) => child !== self.child);
    }

    setChildren(self: Overlay, children: Gtk.Widget[]) {
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

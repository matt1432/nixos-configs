/* eslint-disable @typescript-eslint/no-explicit-any */

import { register } from 'astal';
import { Gtk, type ConstructProps } from 'astal/gtk4';

import astalify, { filter, type } from './astalify';


export type OverlayProps = ConstructProps<
    Overlay,
    Gtk.Overlay.ConstructorProps & { css: string }
>;

@register({ GTypeName: 'Overlay' })
export class Overlay extends astalify(Gtk.Overlay) {
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

    setChildren(self: Overlay, children: any[]) {
        for (const child of filter(children)) {
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

import { register } from 'astal';
import { Gtk, type ConstructProps } from 'astal/gtk4';

import astalify from './astalify';


export type CenterBoxProps = ConstructProps<
    CenterBox,
    Gtk.CenterBox.ConstructorProps & { css: string }
>;

@register({ GTypeName: 'CenterBox' })
export class CenterBox extends astalify(Gtk.CenterBox) {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    constructor(props?: CenterBoxProps) { super(props as any); }

    getChildren(box: CenterBox) {
        return [box.startWidget, box.centerWidget, box.endWidget];
    }

    setChildren(box: CenterBox, children: (Gtk.Widget | null)[]) {
        if (children.length > 3) {
            throw new Error('Cannot have more than 3 children in a CenterBox');
        }

        box.startWidget = children[0] || new Gtk.Box();
        box.centerWidget = children[1] || new Gtk.Box();
        box.endWidget = children[2] || new Gtk.Box();
    }
}

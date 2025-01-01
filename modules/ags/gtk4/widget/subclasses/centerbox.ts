/* eslint-disable @typescript-eslint/no-explicit-any */

import { register } from 'astal';
import { Gtk, type ConstructProps } from 'astal/gtk4';

import astalify, { filter } from './astalify';


export type CenterBoxProps = ConstructProps<
    CenterBox,
    Gtk.CenterBox.ConstructorProps & { css: string }
>;

@register({ GTypeName: 'CenterBox' })
export class CenterBox extends astalify(Gtk.CenterBox) {
    constructor(props?: CenterBoxProps) { super(props as any); }

    getChildren(box: CenterBox) {
        return [box.startWidget, box.centerWidget, box.endWidget];
    }

    setChildren(box: CenterBox, children: any[]) {
        const ch = filter(children);

        box.startWidget = ch[0] || new Gtk.Box();
        box.centerWidget = ch[1] || new Gtk.Box();
        box.endWidget = ch[2] || new Gtk.Box();
    }
}

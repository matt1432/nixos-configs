import { register } from 'astal';
import { Gtk } from 'astal/gtk4';

import astalify, { type AstalifyProps, type ConstructProps } from '../astalify';


export type CenterBoxProps = ConstructProps<
    CenterBoxClass,
    Gtk.CenterBox.ConstructorProps & AstalifyProps
>;

@register({ GTypeName: 'CenterBox' })
export class CenterBoxClass extends astalify(Gtk.CenterBox) {
    constructor({ cssName = 'centerbox', ...props }: CenterBoxProps = {}) {
        super({ cssName, ...props });
    }

    getChildren(box: CenterBoxClass) {
        return [box.startWidget, box.centerWidget, box.endWidget];
    }

    setChildren(box: CenterBoxClass, children: (Gtk.Widget | null)[]) {
        if (children.length > 3) {
            throw new Error('Cannot have more than 3 children in a CenterBox');
        }

        box.startWidget = children[0] || new Gtk.Box();
        box.centerWidget = children[1] || new Gtk.Box();
        box.endWidget = children[2] || new Gtk.Box();
    }
}

export const CenterBox = (props?: CenterBoxProps) => new CenterBoxClass(props);

import { register } from 'astal';
import { Gtk } from 'astal/gtk4';

import astalify, { type AstalifyProps, type ConstructProps } from '../astalify';

type ButtonSignals = Record<`on${string}`, unknown[]> & {
    onClicked: [];
};
export type ButtonProps = ConstructProps<
    ButtonClass,
    Gtk.Button.ConstructorProps & AstalifyProps,
    ButtonSignals
>;

@register({ GTypeName: 'Button' })
export class ButtonClass extends astalify(Gtk.Button) {
    constructor({ cssName = 'button', ...props }: ButtonProps = {}) {
        super({ cssName, ...props });
    }
}

export const Button = (props?: ButtonProps) => new ButtonClass(props);

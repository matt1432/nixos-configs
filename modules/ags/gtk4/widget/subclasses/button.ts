import { register } from 'astal';
import { Gtk, type ConstructProps } from 'astal/gtk4';

import astalify from './astalify';


type ButtonSignals = Record<`on${string}`, unknown[]> & {
    onClicked: []
};
export type ButtonProps = ConstructProps<
    Button,
    Gtk.Button.ConstructorProps & { css: string },
    ButtonSignals
>;

@register({ GTypeName: 'Button' })
export class Button extends astalify(Gtk.Button) {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    constructor(props?: ButtonProps) { super(props as any); }
}

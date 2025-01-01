/* eslint-disable @typescript-eslint/no-explicit-any */

import { register } from 'astal';
import { Gtk, type ConstructProps } from 'astal/gtk4';

import astalify from './astalify';


export type SwitchProps = ConstructProps<
    Switch,
    Gtk.Switch.ConstructorProps & { css: string }
>;

@register({ GTypeName: 'Switch' })
export class Switch extends astalify(Gtk.Switch) {
    constructor(props?: SwitchProps) { super(props as any); }

    getChildren() { return []; }
}

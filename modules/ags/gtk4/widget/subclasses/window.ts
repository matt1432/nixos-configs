/* eslint-disable @typescript-eslint/no-explicit-any */

import { register } from 'astal';
import { Astal, type ConstructProps } from 'astal/gtk4';

import astalify from './astalify';


export type WindowProps = ConstructProps<
    Window,
    Astal.Window.ConstructorProps & { css: string }
>;

@register({ GTypeName: 'Window' })
export class Window extends astalify(Astal.Window) {
    constructor(props?: WindowProps) { super(props as any); }
}

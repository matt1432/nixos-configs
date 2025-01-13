import { register } from 'astal';
import { Astal, type ConstructProps } from 'astal/gtk4';

import astalify, { type AstalifyProps } from './astalify';


export type WindowProps = ConstructProps<
    WindowClass,
    Astal.Window.ConstructorProps & AstalifyProps
>;

@register({ GTypeName: 'Window' })
export class WindowClass extends astalify(Astal.Window) {
    constructor({ cssName = 'window', ...props }: WindowProps = {}) {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        super({ cssName, ...props as any });
    }
}

export const Window = (props?: WindowProps) => new WindowClass(props);

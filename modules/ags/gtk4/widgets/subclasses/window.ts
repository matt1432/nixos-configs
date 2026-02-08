import { register } from 'astal';
import { Astal } from 'astal/gtk4';

import astalify, { type AstalifyProps, type ConstructProps } from '../astalify';

export type WindowProps = ConstructProps<
    WindowClass,
    Astal.Window.ConstructorProps & AstalifyProps
>;

@register({ GTypeName: 'Window' })
export class WindowClass extends astalify(Astal.Window) {
    constructor({ cssName = 'window', ...props }: WindowProps = {}) {
        super({ cssName, ...props });
    }
}

export const Window = (props?: WindowProps) => new WindowClass(props);

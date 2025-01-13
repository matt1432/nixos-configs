import { register } from 'astal';
import { Astal, type ConstructProps } from 'astal/gtk4';

import astalify, { type AstalifyProps } from './astalify';


type SliderSignals = Record<`on${string}`, unknown[]> & {
    onClicked: []
};
export type SliderProps = ConstructProps<
    SliderClass,
    Astal.Slider.ConstructorProps & AstalifyProps,
    SliderSignals
>;

@register({ GTypeName: 'Slider' })
export class SliderClass extends astalify(Astal.Slider) {
    constructor({ cssName = 'slider', ...props }: SliderProps = {}) {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        super({ cssName, ...props as any });
    }

    getChildren() { return []; }
}

export const Slider = (props?: SliderProps) => new SliderClass(props);

import { register } from 'astal';
import { Astal } from 'astal/gtk4';

import astalify, { type AstalifyProps, type ConstructProps } from '../astalify';


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
        super({ cssName, ...props });
    }

    getChildren() { return []; }
}

export const Slider = (props?: SliderProps) => new SliderClass(props);

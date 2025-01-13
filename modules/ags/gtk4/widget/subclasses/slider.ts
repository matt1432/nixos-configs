import { register } from 'astal';
import { Astal, type ConstructProps } from 'astal/gtk4';

import astalify from './astalify';


type SliderSignals = Record<`on${string}`, unknown[]> & {
    onClicked: []
};
export type SliderProps = ConstructProps<
    Slider,
    Astal.Slider.ConstructorProps & { css: string },
    SliderSignals
>;

@register({ GTypeName: 'Slider' })
export class Slider extends astalify(Astal.Slider) {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    constructor(props?: SliderProps) { super(props as any); }

    getChildren() { return []; }
}

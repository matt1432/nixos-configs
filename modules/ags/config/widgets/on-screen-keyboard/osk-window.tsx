import { register } from 'astal/gobject';
import { App, Widget } from 'astal/gtk3';

@register()
export default class OskWindow extends Widget.Window {
    public startY: number | null = null;

    declare public killGestureSigs: () => void;
    declare public setSlideUp: () => void;
    declare public setSlideDown: () => void;

    get_child(): Widget.Box {
        return super.get_child() as Widget.Box;
    }

    get_grandchildren(): (Widget.Box | Widget.CenterBox)[] {
        return this.get_child().get_children() as (
            | Widget.Box
            | Widget.CenterBox
        )[];
    }

    constructor({ ...rest }: Widget.WindowProps) {
        super({ application: App, ...rest });
    }
}

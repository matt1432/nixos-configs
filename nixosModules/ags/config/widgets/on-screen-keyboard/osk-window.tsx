import { App, Widget } from 'astal/gtk3';
import { register } from 'astal/gobject';


@register()
export default class OskWindow extends Widget.Window {
    public startY: number | null = null;

    declare public killGestureSigs: () => void;
    declare public setSlideUp: () => void;
    declare public setSlideDown: () => void;

    get_child(): Widget.Box {
        return super.get_child() as Widget.Box;
    }

    constructor({ ...rest }: Widget.WindowProps) {
        super({ application: App, ...rest });
    }
}

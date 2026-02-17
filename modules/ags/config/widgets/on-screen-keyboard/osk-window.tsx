import { register } from 'ags/gobject';
import { Astal } from 'ags/gtk3';
import app from 'ags/gtk3/app';

@register()
export default class OskWindow extends Astal.Window {
    public startY: number | null = null;

    declare public killGestureSigs: () => void;
    declare public setSlideUp: () => void;
    declare public setSlideDown: () => void;

    get_child(): Astal.Box {
        return super.get_child() as Astal.Box;
    }

    get_grandchildren(): (Astal.Box | Astal.CenterBox)[] {
        return this.get_child().get_children() as (
            | Astal.Box
            | Astal.CenterBox
        )[];
    }

    constructor({ ...rest }: Partial<Astal.Window.ConstructorProps>) {
        super({ ...rest, application: app, visible: true });
    }
}

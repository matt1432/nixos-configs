import { register } from 'ags/gobject';
import { Astal, Gtk } from 'ags/gtk4';
import app from 'ags/gtk4/app';

import { getChildren } from '../../lib/widgets';

@register()
export default class OskWindow extends Astal.Window {
    public startY: number | null = null;

    declare public killGestureSigs: () => void;
    declare public setSlideUp: () => void;
    declare public setSlideDown: () => void;

    get_child(): Gtk.Box {
        return super.get_child() as Gtk.Box;
    }

    get_grandchildren(): Gtk.Widget[] {
        return getChildren(this.get_child());
    }

    constructor({ ...rest }: Partial<Astal.Window.ConstructorProps>) {
        super({ ...rest, application: app });

        // GTK4 windows have to be shown after their layer-shell setup
        this.set_visible(true);
    }
}

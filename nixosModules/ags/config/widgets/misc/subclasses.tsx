import { astalify, Gtk, type ConstructProps } from 'astal/gtk3';
import { register } from 'astal/gobject';


@register()
export class ToggleButton extends astalify(Gtk.ToggleButton) {
    constructor(props: ConstructProps<
        ToggleButton,
        Gtk.ToggleButton.ConstructorProps
    >) {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        super(props as any);
    }
}

@register()
export class ListBox extends astalify(Gtk.ListBox) {
    override get_children() {
        return super.get_children() as Gtk.ListBoxRow[];
    }

    constructor(props: ConstructProps<
        ListBox,
        Gtk.ListBox.ConstructorProps
    >) {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        super(props as any);
    }
}

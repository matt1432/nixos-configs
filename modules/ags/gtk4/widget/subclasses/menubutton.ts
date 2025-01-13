import { register } from 'astal';
import { Gtk, type ConstructProps } from 'astal/gtk4';

import astalify from './astalify';


export type MenuButtonProps = ConstructProps<
    MenuButton,
    Gtk.MenuButton.ConstructorProps & { css: string }
>;

@register({ GTypeName: 'MenuButton' })
export class MenuButton extends astalify(Gtk.MenuButton) {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    constructor(props?: MenuButtonProps) { super(props as any); }

    getChildren(self: MenuButton) {
        return [self.popover, self.child];
    }

    setChildren(self: MenuButton, children: Gtk.Widget[]) {
        for (const child of children) {
            if (child instanceof Gtk.Popover) {
                self.set_popover(child);
            }
            else {
                self.set_child(child);
            }
        }
    }
}

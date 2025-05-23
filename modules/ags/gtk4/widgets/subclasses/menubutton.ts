import { register } from 'astal';
import { Gtk } from 'astal/gtk4';

import astalify, { type AstalifyProps, type ConstructProps } from '../astalify';


export type MenuButtonProps = ConstructProps<
    MenuButtonClass,
    Gtk.MenuButton.ConstructorProps & AstalifyProps
>;

@register({ GTypeName: 'MenuButton' })
export class MenuButtonClass extends astalify(Gtk.MenuButton) {
    constructor({ cssName = 'menubutton', ...props }: MenuButtonProps = {}) {
        super({ cssName, ...props });
    }

    getChildren(self: MenuButtonClass) {
        return [self.popover, self.child];
    }

    setChildren(self: MenuButtonClass, children: Gtk.Widget[]) {
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

export const MenuButton = (props?: MenuButtonProps) => new MenuButtonClass(props);

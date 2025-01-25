import { register } from 'astal';
import { Gtk } from 'astal/gtk4';

import astalify, { type AstalifyProps, type ConstructProps } from '../astalify';


export type LevelBarProps = ConstructProps<
    LevelBarClass,
    Gtk.LevelBar.ConstructorProps & AstalifyProps
>;

@register({ GTypeName: 'LevelBar' })
export class LevelBarClass extends astalify(Gtk.LevelBar) {
    constructor({ cssName = 'levelbar', ...props }: LevelBarProps = {}) {
        super({ cssName, ...props });
    }

    getChildren() { return []; }
}

export const LevelBar = (props?: LevelBarProps) => new LevelBarClass(props);

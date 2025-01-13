import { register } from 'astal';
import { Gtk, type ConstructProps } from 'astal/gtk4';

import astalify, { type AstalifyProps } from './astalify';


export type LevelBarProps = ConstructProps<
    LevelBarClass,
    Gtk.LevelBar.ConstructorProps & AstalifyProps
>;

@register({ GTypeName: 'LevelBar' })
export class LevelBarClass extends astalify(Gtk.LevelBar) {
    constructor({ cssName = 'levelbar', ...props }: LevelBarProps = {}) {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        super({ cssName, ...props as any });
    }

    getChildren() { return []; }
}

export const LevelBar = (props?: LevelBarProps) => new LevelBarClass(props);

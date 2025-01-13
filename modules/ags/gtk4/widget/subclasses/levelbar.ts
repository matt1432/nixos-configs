import { register } from 'astal';
import { Gtk, type ConstructProps } from 'astal/gtk4';

import astalify from './astalify';


export type LevelBarProps = ConstructProps<
    LevelBar,
    Gtk.LevelBar.ConstructorProps & { css: string }
>;

@register({ GTypeName: 'LevelBar' })
export class LevelBar extends astalify(Gtk.LevelBar) {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    constructor(props?: LevelBarProps) { super(props as any); }

    getChildren() { return []; }
}

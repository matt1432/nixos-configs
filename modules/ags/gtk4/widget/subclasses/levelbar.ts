/* eslint-disable @typescript-eslint/no-explicit-any */

import { register } from 'astal';
import { Gtk, type ConstructProps } from 'astal/gtk4';

import astalify from './astalify';


export type LevelBarProps = ConstructProps<
    LevelBar,
    Gtk.LevelBar.ConstructorProps & { css: string }
>;

@register({ GTypeName: 'LevelBar' })
export class LevelBar extends astalify(Gtk.LevelBar) {
    constructor(props?: LevelBarProps) { super(props as any); }

    getChildren() { return []; }
}

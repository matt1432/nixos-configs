/* eslint-disable @typescript-eslint/no-explicit-any */

import { register } from 'astal';
import { Gtk, type ConstructProps } from 'astal/gtk4';

import astalify from './astalify';


type EntrySignals = Record<`on${string}`, unknown[]> & {
    onActivate: []
    onNotifyText: []
};
export type EntryProps = ConstructProps<
    Entry,
    Gtk.Entry.ConstructorProps & { css: string },
    EntrySignals
>;

@register({ GTypeName: 'Entry' })
export class Entry extends astalify(Gtk.Entry) {
    constructor(props?: EntryProps) { super(props as any); }

    getChildren() { return []; }
}

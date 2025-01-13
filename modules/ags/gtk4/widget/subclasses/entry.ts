import { register } from 'astal';
import { Gtk, type ConstructProps } from 'astal/gtk4';

import astalify, { type AstalifyProps } from './astalify';


type EntrySignals = Record<`on${string}`, unknown[]> & {
    onActivate: []
    onNotifyText: []
};
export type EntryProps = ConstructProps<
    EntryClass,
    Gtk.Entry.ConstructorProps & AstalifyProps,
    EntrySignals
>;

@register({ GTypeName: 'Entry' })
export class EntryClass extends astalify(Gtk.Entry) {
    constructor({ cssName = 'entry', ...props }: EntryProps = {}) {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        super({ cssName, ...props as any });
    }

    getChildren() { return []; }
}

export const Entry = (props?: EntryProps) => new EntryClass(props);

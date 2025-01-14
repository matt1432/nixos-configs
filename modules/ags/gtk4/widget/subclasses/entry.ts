import { register } from 'astal';
import { Gtk, type ConstructProps } from 'astal/gtk4';

import astalify, { type AstalifyProps } from '../astalify';


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
        super({ cssName, ...props });
    }

    getChildren() { return []; }
}

export const Entry = (props?: EntryProps) => new EntryClass(props);

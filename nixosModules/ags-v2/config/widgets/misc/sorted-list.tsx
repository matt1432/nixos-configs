// This is definitely not good practice but I couldn't figure out how to extend PopupWindow
// so here we are with a cursed function that returns a prop of the class.

import { Astal, Gtk, Widget } from 'astal/gtk3';
import { idle } from 'astal';

import { AsyncFzf, FzfOptions, FzfResultItem } from 'fzf';

import PopupWindow from '../misc/popup-window';
import { centerCursor } from '../../lib';

export interface SortedListProps<T> {
    create_list: () => T[] | Promise<T[]>
    create_row: (item: T) => Gtk.Widget
    fzf_options?: FzfOptions<T>
    compare_props?: (keyof T)[]
    on_row_activated: (row: Gtk.ListBoxRow) => void
    sort_func: (
        a: Gtk.ListBoxRow,
        b: Gtk.ListBoxRow,
        entry: Widget.Entry,
        fzf: FzfResultItem<T>[],
    ) => number
    name: string
};


export class SortedList<T> {
    private item_list: T[] = [];
    private fzf_results: FzfResultItem<T>[] = [];

    readonly window: PopupWindow;
    private _item_map = new Map<T, Gtk.Widget>();

    readonly create_list: () => T[] | Promise<T[]>;
    readonly create_row: (item: T) => Gtk.Widget;
    readonly fzf_options: FzfOptions<T> | undefined;
    readonly compare_props: (keyof T)[] | undefined;

    readonly on_row_activated: (row: Gtk.ListBoxRow) => void;

    readonly sort_func: (
        a: Gtk.ListBoxRow,
        b: Gtk.ListBoxRow,
        entry: Widget.Entry,
        fzf: FzfResultItem<T>[],
    ) => number;


    constructor({
        create_list,
        create_row,
        fzf_options,
        compare_props,
        on_row_activated,
        sort_func,
        name,
    }: SortedListProps<T>) {
        const list = new Gtk.ListBox({
            selectionMode: Gtk.SelectionMode.SINGLE,
        });

        list.connect('row-activated', (_, row) => {
            this.on_row_activated(row);
        });

        const placeholder = (
            <revealer>
                <label
                    label="   Couldn't find a match"
                    className="placeholder"
                />
            </revealer>
        ) as Widget.Revealer;

        const on_text_change = (text: string) => {
            // @ts-expect-error this should be okay
            (new AsyncFzf(this.item_list, this.fzf_options)).find(text)
                .then((out) => {
                    this.fzf_results = out;
                    list.invalidate_sort();

                    const visibleApplications = list.get_children().filter((row) => row.visible).length;

                    placeholder.reveal_child = visibleApplications <= 0;
                })
                .catch(() => { /**/ });
        };

        const entry = (
            <entry
                onChanged={(self) => on_text_change(self.text)}
                hexpand
            />
        ) as Widget.Entry;

        list.set_sort_func((a, b) => {
            return this.sort_func(a, b, entry, this.fzf_results);
        });

        const refreshItems = () => idle(async() => {
            // Delete items that don't exist anymore
            const new_list = await this.create_list();

            for (const [item, widget] of this._item_map) {
                if (!new_list.some((child) =>
                    this.compare_props?.every((prop) => child[prop] === item[prop]) ?? child === item)) {
                    widget.destroy();
                }
            }

            // Add missing items
            for (const item of new_list) {
                if (!this.item_list.some((child) =>
                    this.compare_props?.every((prop) => child[prop] === item[prop]) ?? child === item)) {
                    const _item = this.create_row(item);

                    list.add(_item);
                }
            }

            this.item_list = new_list;

            list.show_all();
            on_text_change('');
        });

        this.window = (
            <PopupWindow
                name={name}
                keymode={Astal.Keymode.ON_DEMAND}
                on_open={() => {
                    entry.text = '';
                    centerCursor();
                    entry.grab_focus();
                }}
            >
                <box
                    vertical
                    className={`${name} sorted-list`}
                >
                    <box className="widget search">

                        <icon icon="preferences-system-search-symbolic" />

                        {entry}

                        <button
                            css="margin-left: 5px;"
                            cursor="pointer"
                            onButtonReleaseEvent={refreshItems}
                        >
                            <icon icon="view-refresh-symbolic" css="font-size: 26px;" />
                        </button>

                    </box>

                    <eventbox cursor="pointer">
                        <scrollable
                            className="widget list"

                            css="min-height: 600px; min-width: 700px;"
                            hscroll={Gtk.PolicyType.NEVER}
                            vscroll={Gtk.PolicyType.AUTOMATIC}
                        >
                            <box vertical>
                                {list}
                                {placeholder}
                            </box>
                        </scrollable>
                    </eventbox>
                </box>
            </PopupWindow>
        ) as PopupWindow;

        this.create_list = create_list;
        this.create_row = create_row;
        this.fzf_options = fzf_options;
        this.compare_props = compare_props;
        this.on_row_activated = on_row_activated;
        this.sort_func = sort_func;

        refreshItems();
    }
};

/**
 * @param props props for a SortedList Widget
 * @returns the widget
 */
export default function<Attr>(props: SortedListProps<Attr>) {
    return (new SortedList(props)).window;
}

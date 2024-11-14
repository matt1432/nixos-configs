// This is definitely not good practice but I couldn't figure out how to extend PopupWindow
// so here we are with a cursed function that returns a prop of the class.

import { Astal, Gtk, Widget } from 'astal/gtk3';
import { idle } from 'astal';

import { AsyncFzf, AsyncFzfOptions, FzfResultItem } from 'fzf';

import PopupWindow from '../misc/popup-window';
import { centerCursor } from '../../lib';

export interface SortedListProps<T> {
    create_list: () => T[] | Promise<T[]>
    create_row: (item: T) => Gtk.Widget
    fzf_options?: AsyncFzfOptions<T>
    unique_props?: (keyof T)[]
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
    readonly fzf_options: AsyncFzfOptions<T>;
    readonly unique_props: (keyof T)[] | undefined;

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
        fzf_options = {} as AsyncFzfOptions<T>,
        unique_props,
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
            // @ts-expect-error this works
            (new AsyncFzf<T[]>(this.item_list, this.fzf_options)).find(text)
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

            [...this._item_map].forEach(([item, widget]) => {
                if (!new_list.some((new_item) =>
                    this.unique_props?.every((prop) => item[prop] === new_item[prop]) ??
                    item === new_item)) {
                    widget.get_parent()?.destroy();
                    this._item_map.delete(item);
                }
            });

            // Add missing items
            new_list.forEach((item) => {
                if (!this.item_list.some((old_item) =>
                    this.unique_props?.every((prop) => old_item[prop] === item[prop]) ??
                    old_item === item)) {
                    const itemWidget = this.create_row(item);

                    list.add(itemWidget);
                    this._item_map.set(item, itemWidget);
                }
            });

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
                    refreshItems();
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
        this.unique_props = unique_props;
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

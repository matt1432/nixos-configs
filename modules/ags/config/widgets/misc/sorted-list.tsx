import GObject, { register } from 'ags/gobject';
import { Astal, Gtk } from 'ags/gtk4';
import { idle } from 'ags/time';
import { AsyncFzf, AsyncFzfOptions } from 'fzf';
import Gio from 'gi://Gio';

import { centerCursor } from '../../lib';
import { pointer } from '../../lib/widgets';
import PopupWindow from '../misc/popup-window';

/**
 * GObject wrapper so any JS value can be stored in a Gio.ListStore.
 */
@register()
class SortedListItem extends GObject.Object {
    declare value: unknown;

    constructor(value: unknown) {
        super();
        this.value = value;
    }
}

export interface SortedListProps<T> {
    name: string;
    create_list: () => T[] | Promise<T[]>;
    create_row: (item: T) => Gtk.Widget;
    fzf_options?: AsyncFzfOptions<T>;
    /** Props used to tell if an item from a new list is already shown */
    unique_props?: (keyof T)[];
    on_activate: (item: T) => void;
    /** Order of the items when there is no search query */
    compare: (a: T, b: T) => number;
}

export class SortedList<T> {
    readonly window: PopupWindow;

    private readonly store = new Gio.ListStore({
        item_type: SortedListItem.$gtype,
    });

    private readonly widgets = new Map<SortedListItem, Gtk.Widget>();
    private scores = new Map<T, number>();
    private query = '';

    constructor({
        name,
        create_list,
        create_row,
        fzf_options = {} as AsyncFzfOptions<T>,
        unique_props,
        on_activate,
        compare,
    }: SortedListProps<T>) {
        const isSearching = () => this.query !== '' && this.query !== '-';

        const filter = Gtk.CustomFilter.new((obj) => {
            const item = (obj as unknown as SortedListItem).value as T;

            return !isSearching() || (this.scores.get(item) ?? 0) > 0;
        });

        const sorter = Gtk.CustomSorter.new((obj1, obj2) => {
            const a = (obj1 as unknown as SortedListItem).value as T;
            const b = (obj2 as unknown as SortedListItem).value as T;

            const result = isSearching()
                ? (this.scores.get(b) ?? 0) - (this.scores.get(a) ?? 0)
                : compare(a, b);

            return Math.sign(result) as Gtk.Ordering;
        });

        const filtered = new Gtk.FilterListModel({
            model: new Gtk.SortListModel({ model: this.store, sorter }),
            filter,
        });

        const selection = new Gtk.SingleSelection({
            model: filtered,
            autoselect: true,
        });

        const activate = (position: number) => {
            const obj = filtered.get_item(position) as SortedListItem | null;

            if (obj) {
                on_activate(obj.value as T);
            }
        };

        const factory = new Gtk.SignalListItemFactory();

        // Rows are activated with a single click here instead of with
        // ListView's singleClickActivate, which also selects rows on hover
        factory.connect('setup', (_, item) => {
            const listItem = item as Gtk.ListItem;
            const click = new Gtk.GestureClick();

            // Claim the click so the ListView doesn't cancel it on release
            click.connect('pressed', () => {
                click.set_state(Gtk.EventSequenceState.CLAIMED);
            });
            click.connect('released', () => activate(listItem.get_position()));

            const container = new Gtk.Box();

            container.add_controller(click);
            listItem.set_child(container);
        });

        factory.connect('bind', (_, item) => {
            const listItem = item as Gtk.ListItem;
            const obj = listItem.get_item() as SortedListItem;
            let widget = this.widgets.get(obj);

            if (!widget) {
                widget = create_row(obj.value as T);
                this.widgets.set(obj, widget);
            }

            (listItem.get_child() as Gtk.Box).append(widget);
        });

        factory.connect('unbind', (_, item) => {
            const container = (item as Gtk.ListItem).get_child() as Gtk.Box;
            const child = container.get_first_child();

            if (child) {
                container.remove(child);
            }
        });

        const listView = (
            <Gtk.ListView
                model={selection}
                factory={factory}
                cursor={pointer}
                onActivate={(_, position) => activate(position)}
            />
        ) as Gtk.ListView;

        const placeholder = (
            <revealer>
                <label label="   Couldn't find a match" class="placeholder" />
            </revealer>
        ) as Gtk.Revealer;

        const onTextChange = (text: string) => {
            this.query = text;

            const items = this.getItems().map((obj) => obj.value as T);

            // @ts-expect-error fzf's typing doesn't like generics
            new AsyncFzf<T[]>(items, fzf_options)
                .find(text)
                .then((results) => {
                    // Ignore results of outdated queries
                    if (text !== this.query) {
                        return;
                    }

                    this.scores = new Map(
                        results.map((r) => [r.item as T, r.score]),
                    );

                    filter.changed(Gtk.FilterChange.DIFFERENT);
                    sorter.changed(Gtk.SorterChange.DIFFERENT);

                    placeholder.set_reveal_child(filtered.get_n_items() === 0);

                    if (filtered.get_n_items() > 0) {
                        listView.scroll_to(0, Gtk.ListScrollFlags.SELECT, null);
                    }
                })
                .catch(() => {});
        };

        const entry = (
            <entry
                hexpand
                onNotifyText={(self) => onTextChange(self.text)}
                onActivate={() => activate(selection.get_selected())}
            />
        ) as Gtk.Entry;

        const refreshItems = () => {
            const isSame = (a: T, b: T) =>
                unique_props?.every((prop) => a[prop] === b[prop]) ?? a === b;

            idle(() => {
                Promise.resolve(create_list())
                    .then((newList) => {
                        const oldItems = this.getItems();

                        // Delete items that don't exist anymore
                        for (let i = oldItems.length - 1; i >= 0; i--) {
                            const obj = oldItems[i];

                            if (
                                !newList.some((item) =>
                                    isSame(obj.value as T, item),
                                )
                            ) {
                                this.store.remove(i);
                                this.widgets.delete(obj);
                            }
                        }

                        // Add missing items
                        const added = newList
                            .filter(
                                (item) =>
                                    !oldItems.some((obj) =>
                                        isSame(obj.value as T, item),
                                    ),
                            )
                            .map((item) => new SortedListItem(item));

                        this.store.splice(this.store.get_n_items(), 0, added);

                        onTextChange(entry.text);
                    })
                    .catch(console.error);
            });
        };

        this.window = (
            <PopupWindow
                name={name}
                keymode={Astal.Keymode.ON_DEMAND}
                open_callback={() => {
                    entry.set_text('');
                    refreshItems();
                    centerCursor();
                    entry.grab_focus();
                }}
            >
                <box
                    orientation={Gtk.Orientation.VERTICAL}
                    class={`${name} sorted-list`}
                >
                    <box class="widget search">
                        <image iconName="preferences-system-search-symbolic" />

                        {entry}

                        <button
                            css="margin-left: 5px;"
                            cursor={pointer}
                            onClicked={refreshItems}
                        >
                            <image
                                iconName="view-refresh-symbolic"
                                pixelSize={26}
                            />
                        </button>
                    </box>

                    <box
                        class="widget list"
                        orientation={Gtk.Orientation.VERTICAL}
                    >
                        <scrolledwindow
                            css="min-height: 600px; min-width: 700px;"
                            vexpand
                            hscrollbarPolicy={Gtk.PolicyType.NEVER}
                            vscrollbarPolicy={Gtk.PolicyType.AUTOMATIC}
                        >
                            {listView}
                        </scrolledwindow>

                        {placeholder}
                    </box>
                </box>
            </PopupWindow>
        ) as PopupWindow;

        refreshItems();
    }

    private getItems(): SortedListItem[] {
        const items: SortedListItem[] = [];

        for (let i = 0; i < this.store.get_n_items(); i++) {
            items.push(this.store.get_item(i) as SortedListItem);
        }

        return items;
    }
}

/**
 * @param props props for a SortedList Widget
 * @returns the widget
 */
export default function <T>(props: SortedListProps<T>) {
    return new SortedList(props).window;
}

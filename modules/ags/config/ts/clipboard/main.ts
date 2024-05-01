const { Box, Entry, Icon, Label, ListBox, Scrollable } = Widget;
const { execAsync } = Utils;

import { Fzf, FzfResultItem } from 'fzf';
import Gtk from 'gi://Gtk?version=3.0';

import CursorBox from '../misc/cursorbox.ts';
import PopupWindow from '../misc/popup.ts';


const N_ITEMS = 30;

const copyOldItem = (key: string | number): void => {
    execAsync([
        'bash', '-c', `cliphist list | grep ${key} | cliphist decode | wl-copy`,
    ]).then(() => {
        App.closeWindow('win-clipboard');
    });
};

export default () => {
    let CopiedItems = [] as [string, number][];

    let fzfResults: FzfResultItem<[string, number]>[];
    const list = ListBox();

    const getKey = (r: Gtk.ListBoxRow) => parseInt(r.get_child()?.name ?? '');

    const updateItems = () => {
        (list.get_children() as Gtk.ListBoxRow[]).forEach((r) => {
            r.changed();
        });
    };

    const setSort = (text: string) => {
        if (text === '' || text === '-') {
            list.set_sort_func((row1, row2) => getKey(row2) - getKey(row1));
        }
        else {
            const fzf = new Fzf(CopiedItems, {
                selector: (item) => item[0],

                tiebreakers: [(a, b) => b[1] - a[1]],
            });

            fzfResults = fzf.find(text);
            list.set_sort_func((a, b) => {
                const row1 = fzfResults.find((f) => f.item[1] === getKey(a))?.score ?? 0;
                const row2 = fzfResults.find((f) => f.item[1] === getKey(b))?.score ?? 0;

                return row2 - row1;
            });
        }
        updateItems();
    };

    const makeItem = (key: string, val: string) => {
        CopiedItems.push([val, parseInt(key)]);

        const widget = CursorBox({
            class_name: 'item',
            name: key,

            on_primary_click_release: () => copyOldItem(key),

            child: Box({
                children: [
                    val.startsWith('img:') ?
                        Icon({
                            icon: val.replace('img:', ''),
                            size: 100 * 2,
                        }) :

                        Label({
                            label: val,
                            truncate: 'end',
                            max_width_chars: 100,
                        }),
                ],
            }),
        });

        list.add(widget);
        widget.show_all();
        updateItems();
    };

    // Decode old item:
    const decodeItem = (index: string) => {
        execAsync([
            'bash', '-c', `cliphist list | grep ${index} | cliphist decode`,
        ]).then((out) => {
            makeItem(index, out);
        });
    };

    const entry = Entry({
        // Set some text so on-change works the first time
        text: '-',
        hexpand: true,

        on_accept: () => {
            const copiedItem = CopiedItems.find((c) => c === fzfResults[0].item);

            if (copiedItem) {
                copyOldItem(copiedItem[1]);
            }
        },

        on_change: ({ text }) => {
            if (text !== null) {
                setSort(text);
            }
        },
    });

    const on_open = () => {
        CopiedItems = [];
        entry.text = '';

        execAsync('clipboard-manager').then((out) => {
            list.get_children()?.forEach((ch) => {
                ch.destroy();
            });

            const items = out.split('\n');

            for (let i = 0; i < N_ITEMS; ++i) {
                if (items[i].includes('img')) {
                    makeItem((items[i].match('[0-9]+') ?? [''])[0], items[i]);
                }
                else {
                    decodeItem(items[i]);
                }
            }
        }).catch(console.log);
    };

    on_open();

    return PopupWindow({
        name: 'clipboard',
        keymode: 'on-demand',
        on_open,

        child: Box({
            class_name: 'clipboard',
            vertical: true,
            children: [
                Box({
                    class_name: 'header',
                    children: [
                        Icon('preferences-system-search-symbolic'),
                        entry,
                    ],
                }),

                Scrollable({
                    hscroll: 'never',
                    vscroll: 'automatic',
                    child: Box({
                        vertical: true,
                        children: [list],
                    }),
                }),
            ],
        }),
    });
};

const { Box, Icon, Label } = Widget;
const { execAsync } = Utils;

import { Fzf, FzfResultItem } from 'fzf';
import Gtk from 'gi://Gtk?version=3.0';

import CursorBox from '../misc/cursorbox.ts';
import SortedList from '../misc/sorted-list.ts';


const N_ITEMS = 30;

const copyOldItem = (key: string | number): void => {
    execAsync([
        'bash', '-c', `cliphist list | grep ${key} | cliphist decode | wl-copy`,
    ]);
    App.closeWindow('win-clipboard');
};

export default () => {
    let CopiedItems = [] as [string, number][];
    let fzfResults: FzfResultItem<[string, number]>[];

    const getKey = (r: Gtk.ListBoxRow) => parseInt(r.get_child()?.name ?? '');

    const makeItem = (list: Gtk.ListBox, key: string, val: string) => {
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
    };

    // Decode old item:
    const decodeItem = (list: Gtk.ListBox, index: string) => {
        execAsync([
            'bash', '-c', `cliphist list | grep ${index} | cliphist decode`,
        ]).then((out) => {
            makeItem(list, index, out);
        });
    };

    return SortedList({
        name: 'clipboard',
        class_name: 'clipboard',
        transition: 'slide top',

        on_select: (r) => copyOldItem(getKey(r)),

        init_rows: (list) => {
            CopiedItems = [];

            execAsync('clipboard-manager').then((out) => {
                list.get_children()?.forEach((ch) => {
                    ch.destroy();
                });

                const items = out.split('\n');

                for (let i = 0; i < N_ITEMS; ++i) {
                    if (items[i].includes('img')) {
                        makeItem(list, (items[i].match('[0-9]+') ?? [''])[0], items[i]);
                    }
                    else {
                        decodeItem(list, items[i]);
                    }
                }
            }).catch(console.error);
        },

        set_sort: (text, list) => {
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
        },
    });
};

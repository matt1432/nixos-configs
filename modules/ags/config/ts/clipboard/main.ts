const { Box, Icon, Label, ListBox, Scrollable } = Widget;
const { execAsync } = Utils;

import Gtk from 'gi://Gtk?version=3.0';

import CursorBox from '../misc/cursorbox.ts';
import PopupWindow from '../misc/popup.ts';


const N_ITEMS = 30;

export default () => {
    const list = ListBox();

    list.set_sort_func((row1, row2) => {
        const getKey = (r: Gtk.ListBoxRow) => parseInt(r.get_child()?.name ?? '');

        return getKey(row2) - getKey(row1);
    });

    const updateItems = () => {
        (list.get_children() as Gtk.ListBoxRow[]).forEach((r) => {
            r.changed();
        });
    };

    const makeItem = (key: string, val: string) => {
        const widget = CursorBox({
            class_name: 'item',
            name: key,

            on_primary_click_release: () => {
                execAsync([
                    'bash', '-c', `cliphist list | grep ${key} | cliphist decode | wl-copy`,
                ]).then(() => {
                    App.closeWindow('win-clipboard');
                });
            },

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

    const on_open = () => {
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
        on_open,

        child: Box({
            class_name: 'clipboard',
            children: [
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

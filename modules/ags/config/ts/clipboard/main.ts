const { Box, Icon, Label } = Widget;

import { Fzf, FzfResultItem } from 'fzf';
import Gtk from 'gi://Gtk?version=3.0';
import Clipboard from '../../services/clipboard.ts';

import CursorBox from '../misc/cursorbox.ts';
import SortedList from '../misc/sorted-list.ts';


export default () => {
    let fzfResults: FzfResultItem<[number, { clip: string, isImage: boolean }]>[];

    const getKey = (r: Gtk.ListBoxRow): number => parseInt(r.get_child()?.name ?? '0');

    const makeItem = (
        list: Gtk.ListBox,
        key: number,
        val: string,
        isImage: boolean,
    ): void => {
        const widget = CursorBox({
            class_name: 'item',
            name: key.toString(),

            on_primary_click_release: () => Clipboard.copyOldItem(key),

            child: Box({
                children: [
                    isImage ?
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


    return SortedList({
        name: 'clipboard',
        class_name: 'clipboard',
        transition: 'slide top',

        on_select: (r) => Clipboard.copyOldItem(getKey(r)),

        init_rows: (list) => {
            Clipboard.getHistory();

            const connectId = Clipboard.connect('history-searched', () => {
                list.get_children().forEach((row) => {
                    row.destroy();
                });
                Clipboard.clips.forEach((clip, key) => {
                    makeItem(list, key, clip.clip, clip.isImage);
                });
                Clipboard.disconnect(connectId);
            });
        },

        set_sort: (text, list) => {
            if (text === '' || text === '-') {
                list.set_sort_func((row1, row2) => getKey(row2) - getKey(row1));
            }
            else {
                const fzf = new Fzf([...Clipboard.clips.entries()], {
                    selector: ([_key, { clip }]) => clip,

                    tiebreakers: [(a, b) => b[0] - a[0]],
                });

                fzfResults = fzf.find(text);
                list.set_sort_func((a, b) => {
                    const row1 = fzfResults.find((f) => f.item[0] === getKey(a))?.score ?? 0;
                    const row2 = fzfResults.find((f) => f.item[0] === getKey(b))?.score ?? 0;

                    return row2 - row1;
                });
            }
        },
    });
};

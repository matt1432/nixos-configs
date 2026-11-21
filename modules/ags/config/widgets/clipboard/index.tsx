import { Gtk } from 'ags/gtk4';
import { execAsync } from 'ags/process';

import { getWindow } from '../../lib';
import SortedList from '../misc/sorted-list';
import { CLIP_SCRIPT, ClipItem, EntryObject } from './clip-item';

export default () =>
    SortedList<EntryObject>({
        name: 'clipboard',

        create_list: async () => {
            const output = await execAsync(`${CLIP_SCRIPT} --get`)
                .then((str) => str)
                .catch((err) => {
                    print(err);

                    return '';
                });

            return output
                .split('\n')
                .filter((line) => line.trim() !== '')
                .map((entry) => {
                    const [id, ...content] = entry.split('\t');

                    return {
                        id: parseInt(id.trim()),
                        content: content.join(' ').trim(),
                        entry,
                    };
                });
        },

        create_row: (item) => (<ClipItem item={item} />) as Gtk.Widget,

        fzf_options: {
            selector: (item) => item.content,
        },

        unique_props: ['id'],

        on_activate: (item) => {
            execAsync(`${CLIP_SCRIPT} --copy-by-id ${item.id}`);
            getWindow('win-clipboard')?.set_visible(false);
        },

        compare: (a, b) => b.id - a.id,
    });

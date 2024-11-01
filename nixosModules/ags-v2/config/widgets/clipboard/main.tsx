import { execAsync } from 'astal';
import { App } from 'astal/gtk3';

import SortedList from '../misc/sorted-list';

import { CLIP_SCRIPT, ClipItem, EntryObject } from './clip-item';


export default () => SortedList<EntryObject>({
    name: 'clipboard',

    create_list: async() => {
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

                return { id: parseInt(id.trim()), content: content.join(' ').trim(), entry };
            });
    },

    create_row: (item) => <ClipItem item={item} />,

    fzf_options: {
        selector: (item) => item.content,
    },

    unique_props: ['id'],

    on_row_activated: (row) => {
        const clip = row.get_children()[0] as ClipItem;

        execAsync(`${CLIP_SCRIPT} --copy-by-id ${clip.id}`);
        App.get_window('win-clipboard')?.set_visible(false);
    },

    sort_func: (a, b, entry, fzfResults) => {
        const row1 = a.get_children()[0] as ClipItem;
        const row2 = b.get_children()[0] as ClipItem;

        if (entry.text === '' || entry.text === '-') {
            a.set_visible(true);
            b.set_visible(true);

            return row2.id - row1.id;
        }
        else {
            const s1 = fzfResults.find((r) => r.item.id === row1.id)?.score ?? 0;
            const s2 = fzfResults.find((r) => r.item.id === row2.id)?.score ?? 0;

            a.set_visible(s1 !== 0);
            b.set_visible(s2 !== 0);

            return s2 - s1;
        }
    },
});

import { register } from 'ags/gobject';
import { Astal, Gtk } from 'ags/gtk3';
import { execAsync } from 'ags/process';

export interface EntryObject {
    id: number;
    content: string;
    entry: string;
}

const SCALE = 150;
const BINARY_DATA = /\[\[ binary data (\d+) (KiB|MiB) (\w+) (\d+)x(\d+) \]\]/;

export const CLIP_SCRIPT = `${SRC}/widgets/clipboard/cliphist.sh`;

@register()
export class ClipItem extends Astal.Box {
    declare id: number;
    declare content: string;

    public show_image(
        file: string,
        width: string | number,
        height: string | number,
    ) {
        this.children[2].destroy();

        const initCss = () => {
            const _widthPx = Number(width);
            const heightPx = Number(height);
            const maxWidth = 400;
            const widthPx = (_widthPx / heightPx) * SCALE;

            let css = `background-image: url("${file}");`;

            if (widthPx > maxWidth) {
                const newHeightPx = (SCALE / widthPx) * maxWidth;

                css += `min-height: ${newHeightPx}px; min-width: ${maxWidth}px;`;
            }
            else {
                css += `min-height: 150px; min-width: ${widthPx}px;`;
            }

            return css;
        };

        const icon = <box valign={Gtk.Align.CENTER} css={initCss()} />;

        this.children = [...this.children, icon as Gtk.Widget];
    }

    constructor({ item }: { item: EntryObject }) {
        super();
        this.set_children([
            <label
                label={item.id.toString()}
                xalign={0}
                valign={Gtk.Align.CENTER}
            />,
            <label label="・" xalign={0} valign={Gtk.Align.CENTER} />,
            <label
                label={item.content}
                xalign={0}
                valign={Gtk.Align.CENTER}
                truncate
            />,
        ] as Gtk.Widget[]);

        this.id = item.id;
        this.content = item.content;

        const matches = this.content.match(BINARY_DATA);

        if (matches) {
            // const size = matches[1];
            const format = matches[3];
            const width = matches[4];
            const height = matches[5];

            if (format === 'png') {
                execAsync(`${CLIP_SCRIPT} --save-by-id ${this.id}`)
                    .then((file) => {
                        this.show_image(file, width, height);
                    })
                    .catch(print);
            }
        }
    }
}

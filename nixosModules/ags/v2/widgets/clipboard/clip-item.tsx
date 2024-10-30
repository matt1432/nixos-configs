import { execAsync } from 'astal';
import { register } from 'astal/gobject';
import { Gtk, Widget } from 'astal/gtk3';

export interface EntryObject {
    id: number
    content: string
    entry: string
}

const SCALE = 150;
const BINARY_DATA = /\[\[ binary data (\d+) (KiB|MiB) (\w+) (\d+)x(\d+) \]\]/;

export const CLIP_SCRIPT = `${SRC}/widgets/clipboard/cliphist.sh`;

@register()
export class ClipItem extends Widget.Box {
    declare id: number;
    declare content: string;

    public show_image(file: string, width: string | number, height: string | number) {
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

        const icon = (
            <box
                valign={Gtk.Align.CENTER}
                css={initCss()}
            />
        );

        this.children = [...this.children, icon];
    };

    constructor({ item }: { item: EntryObject }) {
        super({
            children: [
                <label
                    label={item.id.toString()}
                    xalign={0}
                    valign={Gtk.Align.CENTER}
                />,
                <label
                    label="・"
                    xalign={0}
                    valign={Gtk.Align.CENTER}
                />,
                <label
                    label={item.content}
                    xalign={0}
                    valign={Gtk.Align.CENTER}
                    truncate
                />,
            ],
        });

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

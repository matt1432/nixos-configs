import { Gtk } from 'ags/gtk4';
import { execAsync } from 'ags/process';
import Pango from 'gi://Pango';

export interface EntryObject {
    id: number;
    content: string;
    entry: string;
}

const SCALE = 150;
const BINARY_DATA = /\[\[ binary data (\d+) (KiB|MiB) (\w+) (\d+)x(\d+) \]\]/;

export const CLIP_SCRIPT = `${SRC}/widgets/clipboard/cliphist.sh`;

const imageCss = (
    file: string,
    width: string | number,
    height: string | number,
) => {
    const _widthPx = Number(width);
    const heightPx = Number(height);
    const maxWidth = 400;
    const widthPx = (_widthPx / heightPx) * SCALE;

    let css = `background-image: url("file://${file}");`;

    if (widthPx > maxWidth) {
        const newHeightPx = (SCALE / widthPx) * maxWidth;

        css += `min-height: ${newHeightPx}px; min-width: ${maxWidth}px;`;
    }
    else {
        css += `min-height: 150px; min-width: ${widthPx}px;`;
    }

    return css;
};

export const ClipItem = ({ item }: { item: EntryObject }) => {
    const content = (
        <label
            label={item.content}
            xalign={0}
            valign={Gtk.Align.CENTER}
            ellipsize={Pango.EllipsizeMode.END}
        />
    ) as Gtk.Label;

    const self = (
        <box>
            <label
                label={item.id.toString()}
                xalign={0}
                valign={Gtk.Align.CENTER}
            />
            <label label="・" xalign={0} valign={Gtk.Align.CENTER} />
            {content}
        </box>
    ) as Gtk.Box;

    const matches = item.content.match(BINARY_DATA);

    if (matches) {
        // const size = matches[1];
        const format = matches[3];
        const width = matches[4];
        const height = matches[5];

        if (format === 'png') {
            execAsync(`${CLIP_SCRIPT} --save-by-id ${item.id}`)
                .then((file) => {
                    self.remove(content);
                    self.append(
                        (
                            <box
                                valign={Gtk.Align.CENTER}
                                css={imageCss(file, width, height)}
                            />
                        ) as Gtk.Box,
                    );
                })
                .catch(print);
        }
    }

    return self;
};

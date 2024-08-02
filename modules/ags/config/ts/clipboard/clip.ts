const { Box, Button, Icon, Label, Revealer } = Widget;


const ImageClip = (key: number, val: string) => Box({
    class_name: 'item',
    name: key.toString(),

    child: Icon({
        icon: val.replace('img:', ''),
        size: 100 * 2,
    }),
});

const TextClip = (key: number, val: string) => {
    const lines = val.split('\n');

    if (lines.length <= 5) {
        return Box({
            class_name: 'item',
            name: key.toString(),

            child: Label({
                label: val,
                truncate: 'end',
                max_width_chars: 100,
            }),
        });
    }
    else {
        const revText = Revealer({
            hpack: 'start',
            child: Label({
                label: lines.slice(2, lines.length).join('\n'),
                truncate: 'end',
                max_width_chars: 100,
            }),
        });

        return Box({
            class_name: 'item',
            name: key.toString(),

            vertical: true,
            children: [
                Label({
                    label: lines.slice(0, 2).join('\n'),
                    truncate: 'end',
                    max_width_chars: 100,
                    hpack: 'start',
                }),

                revText,

                Button({
                    child: Icon({
                        class_name: 'down-arrow',
                        icon: 'down-large-symbolic',
                        size: 24,
                    }),

                    on_primary_click_release: (self) => {
                        const state = !revText.reveal_child;

                        revText.reveal_child = state;

                        self.child.setCss(`
                            -gtk-icon-transform: rotate(${state ? '180' : '0'}deg);
                        `);
                    },
                }),
            ],
        });
    }
};

export default ({
    key = 0,
    isImage = false,
    val = '',
}) => isImage ? ImageClip(key, val) : TextClip(key, val);

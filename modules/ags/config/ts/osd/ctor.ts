import { Box, Icon, ProgressBar } from 'resource:///com/github/Aylur/ags/widget.js';

const Y_POS = 80;

// Types
import AgsBox from 'types/widgets/box';
import { IconProps } from 'types/widgets/icon';
import GObject from 'types/@girs/gobject-2.0/gobject-2.0';
import AgsStack from 'types/widgets/stack';
import { Widget } from 'types/@girs/gtk-3.0/gtk-3.0.cjs';
import { Connectable } from 'types/widgets/widget';
import AgsProgressBar from 'types/widgets/progressbar';
type ConnectFunc = (self?: AgsProgressBar) => void;
type OSD = {
    stack: AgsStack
    icon: string | IconProps
    info: {
        mod: GObject.Object
        signal?: string
        logic?(self: AgsProgressBar): void
        widget?: Widget
    }
};


export default ({ stack, icon, info }: OSD) => {
    let connectFunc: ConnectFunc;

    const osd = Box({
        css: `margin-bottom: ${Y_POS}px;`,
        children: [Box({
            class_name: 'osd',
            children: [
                Icon({
                    hpack: 'start',
                    // Can take a string or an object of props
                    ...(typeof icon === 'string' ? { icon } : icon),
                }),
                // Can take a static widget instead of a progressbar
                info.widget ?
                    info.widget :
                    ProgressBar({ vpack: 'center' }),
            ],
        })],
    });

    // Handle requests to show the OSD
    // Different wether it's a bar or static
    if (info.logic) {
        connectFunc = (self) => new Promise<void>((r) => {
            if (info.logic && self) {
                info.logic(self);
            }
            r();
        }).then(() => stack.attribute.popup(osd));
    }
    else {
        connectFunc = () => stack.attribute.popup(osd);
    }

    ((osd.children[0] as AgsBox).children[1] as Connectable<AgsProgressBar>)
        .hook(info.mod, connectFunc, info.signal);

    return osd;
};

import { Box, Icon, ProgressBar } from 'resource:///com/github/Aylur/ags/widget.js';

const Y_POS = 80;

// Types
import AgsBox from 'types/widgets/box';
import { IconProps } from 'types/widgets/icon';
import { GObject } from 'gi://GObject';
import AgsStack from 'types/widgets/stack';
type Widget = typeof imports.gi.Gtk.Widget;
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
                info.logic ?
                    ProgressBar({ vpack: 'center' }) :
                    info.widget,
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

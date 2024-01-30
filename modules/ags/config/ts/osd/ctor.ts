import { Box, Icon, ProgressBar } from 'resource:///com/github/Aylur/ags/widget.js';

const Y_POS = 80;

// Types
import { ConnectFunc, OSD, ProgressBarGeneric } from 'global-types';


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

    (osd.children[0].children[1] as ProgressBarGeneric)
        .hook(info.mod, connectFunc, info.signal);

    return osd;
};

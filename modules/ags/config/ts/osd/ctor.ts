const { Box, Icon, ProgressBar } = Widget;

const Y_POS = 80;

// Types
import { ConnectFunc, OSD, OSDStack } from 'global-types';


export default ({ name, icon, info }: OSD) => {
    let connectFunc: ConnectFunc;
    const status = info.widget ?
        info.widget :
        ProgressBar({ vpack: 'center' });

    // Wrapper to get sliding up anim
    const osd = Box({
        name,
        css: `margin-bottom: ${Y_POS}px;`,
        children: [
            // Actual OSD
            Box({
                class_name: 'osd',
                children: [
                    Icon({
                        hpack: 'start',
                        icon,
                    }),
                    status,
                ],
            }),
        ],
    });

    // Handle requests to show the OSD
    // Different wether it's a bar or static
    if (info.logic) {
        connectFunc = (self) => new Promise<void>((r) => {
            if (info.logic && self) {
                info.logic(self);
            }
            r();
        }).then(() => (osd.get_parent() as OSDStack)?.attribute?.popup(name))
            .catch(console.error);
    }
    else {
        connectFunc = () => (osd.get_parent() as OSDStack)
            ?.attribute?.popup(name);
    }

    if (info.signal) {
        if (typeof info.signal === 'string') {
            status.hook(info.mod, connectFunc, info.signal);
        }
        else {
            info.signal.forEach((sig) => {
                status.hook(info.mod, connectFunc, sig);
            });
        }
    }

    return osd;
};

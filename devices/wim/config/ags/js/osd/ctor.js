import { Box, Icon, ProgressBar } from 'resource:///com/github/Aylur/ags/widget.js';

const Y_POS = 80;


export default ({ stack, icon, info } = {}) => {
    let connectFunc;

    const osd = Box({
        css: `margin-bottom: ${Y_POS}px;`,
        children: [Box({
            className: 'osd',
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
        connectFunc = (self) => new Promise((r) => {
            info.logic(self);
            r();
        }).then(() => stack.popup(osd));
    }
    else {
        connectFunc = () => stack.popup(osd);
    }

    osd.children[0].children[1].hook(info.mod, connectFunc, info.signal);

    return osd;
};

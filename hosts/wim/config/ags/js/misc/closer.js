import { App, Utils, Widget } from '../../imports.js';
const { Window, Revealer } = Widget;

import Pointers from '../../services/pointers.js';

const ALWAYS_OPEN = [
    'closer',
    'bar',
    'notifications',
    'cornertl',
    'cornertr',
    'cornerbl',
    'cornerbr',
];


const closeAll = () => {
    App.windows.forEach(w => {
        if (!ALWAYS_OPEN.some(window => window === w.name))
            App.closeWindow(w.name);
    });
    App.closeWindow('closer');
};
globalThis.closeAll = closeAll;

Pointers.connect('new-line', (_, out) => {
    if (out) {
        Utils.execAsync('hyprctl layers -j').then(layers => {
            layers = JSON.parse(layers);

            Utils.execAsync('hyprctl cursorpos -j').then(pos => {
                pos = JSON.parse(pos);

                Object.values(layers).forEach(key => {
                    const bar = key['levels']['3']
                        .find(n => n.namespace === 'bar');

                    const widgets = key['levels']['3']
                        .filter(n => !ALWAYS_OPEN.includes(n.namespace));

                    if (pos.x > bar.x && pos.x < bar.x + bar.w &&
                        pos.y > bar.y && pos.y < bar.y + bar.h) {

                        // don't handle clicks when on bar
                    }
                    else {
                        widgets.forEach(l => {
                            if (!(pos.x > l.x && pos.x < l.x + l.w &&
                                  pos.y > l.y && pos.y < l.y + l.h)) {
                                closeAll();
                                return;
                            }
                        });
                    }
                });
            }).catch(print);
        }).catch(print);
    }
});

export default () => Window({
    name: 'closer',
    popup: true,
    layer: 'top',

    child: Revealer({
        connections: [[App, (_, windowName, visible) => {
            const anyVisibleAndClosable = Array.from(App.windows).some(w => {
                const isAlwaysOpen = ALWAYS_OPEN.some(window => window === w[0]);

                return w[1].visible && !isAlwaysOpen;
            });

            if (!anyVisibleAndClosable)
                App.closeWindow('closer');

            if (windowName === 'closer') {
                if (visible)
                    Pointers.startProc();
                else
                    Pointers.killProc();
            }
        }]],
    }),
});

import App from 'resource:///com/github/Aylur/ags/app.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Service from 'resource:///com/github/Aylur/ags/service.js';

import { subprocess } from 'resource:///com/github/Aylur/ags/utils.js';

const ON_RELEASE_TRIGGERS = [
    'released',
    'TOUCH_UP',
    'HOLD_END',
];
const ON_CLICK_TRIGGERS = [
    'pressed',
    'TOUCH_DOWN',
];

// Types
import AgsWindow from 'types/widgets/window';
type Subprocess = typeof imports.gi.Gio.Subprocess;
type Layer = {
    address: string;
    x: number;
    y: number;
    w: number;
    h: number;
    namespace: string;
};
type Levels = {
    0?: Array<Layer> | null;
    1?: Array<Layer> | null;
    2?: Array<Layer> | null;
    3?: Array<Layer> | null;
};
type Layers = {
    levels: Levels;
};
type CursorPos = {
    x: number;
    y: number;
};


class Pointers extends Service {
    static {
        Service.register(this, {
            'proc-started': ['boolean'],
            'proc-destroyed': ['boolean'],
            'device-fetched': ['boolean'],
            'new-line': ['string'],
            'released': ['string'],
            'clicked': ['string'],
        });
    }

    #process: Subprocess;
    #lastLine = '';
    #pointers = [] as Array<String>;

    get process() {
        return this.#process;
    }

    get lastLine() {
        return this.#lastLine;
    }

    get pointers() {
        return this.#pointers;
    }

    constructor() {
        super();
        this.#initAppConnection();
    }

    startProc() {
        if (this.#process) {
            return;
        }

        this.#process = subprocess(
            ['libinput', 'debug-events'],
            (output) => {
                if (output.includes('cancelled')) {
                    return;
                }

                if (ON_RELEASE_TRIGGERS.some((p) => output.includes(p))) {
                    this.#lastLine = output;
                    Pointers.detectClickedOutside('released');
                    this.emit('released', output);
                    this.emit('new-line', output);
                }

                if (ON_CLICK_TRIGGERS.some((p) => output.includes(p))) {
                    this.#lastLine = output;
                    Pointers.detectClickedOutside('clicked');
                    this.emit('clicked', output);
                    this.emit('new-line', output);
                }
            },
        );
        this.emit('proc-started', true);
    }

    killProc() {
        if (this.#process) {
            this.#process.force_exit();
            this.#process = null;
            this.emit('proc-destroyed', true);
        }
    }

    #initAppConnection() {
        App.connect('window-toggled', () => {
            const anyVisibleAndClosable =
                (Array.from(App.windows) as Array<[string, AgsWindow]>)
                    .some((w) => {
                        const closable = w[1].attribute?.close_on_unfocus &&
                            !(w[1].attribute.close_on_unfocus === 'none' ||
                            w[1].attribute.close_on_unfocus === 'stay');

                        return w[1].visible && closable;
                    });

            if (anyVisibleAndClosable) {
                this.startProc();
            }

            else {
                this.killProc();
            }
        });
    }

    static detectClickedOutside(clickStage: string) {
        const toClose = (Array.from(App.windows) as Array<[string, AgsWindow]>)
            .some((w) => {
                const closable = (w[1].attribute?.close_on_unfocus &&
                    w[1].attribute.close_on_unfocus === clickStage);

                return w[1].visible && closable;
            });

        if (!toClose) {
            return;
        }

        Hyprland.sendMessage('j/layers').then((response) => {
            const layers = JSON.parse(response) as { Layers: Layers };

            Hyprland.sendMessage('j/cursorpos').then((res) => {
                const pos = JSON.parse(res) as CursorPos;

                Object.values(layers).forEach((key) => {
                    const overlayLayer = key.levels['3'];

                    if (overlayLayer) {
                        const noCloseWidgetsNames = ['bar', 'osk'];

                        const getNoCloseWidgets = (names: Array<string>) => {
                            const arr = [] as Array<Layer>;

                            names.forEach((name) => {
                                arr.push(
                                    overlayLayer.find(
                                        (n) => n.namespace === name,
                                    ) ||
                                    // Return an empty Layer if widget doesn't exist
                                    {
                                        address: '',
                                        x: 0, y: 0, w: 0, h: 0,
                                        namespace: '',
                                    },
                                );
                            });

                            return arr;
                        };
                        const clickIsOnWidget = (w: Layer) => {
                            return pos.x > w.x && pos.x < w.x + w.w &&
                                   pos.y > w.y && pos.y < w.y + w.h;
                        };

                        const noCloseWidgets =
                            getNoCloseWidgets(noCloseWidgetsNames);

                        const widgets = overlayLayer.filter((n) => {
                            const window =
                                    (App.getWindow(n.namespace) as AgsWindow);

                            return window &&
                                window.attribute?.close_on_unfocus &&
                                window.attribute?.close_on_unfocus ===
                                    clickStage;
                        });

                        if (noCloseWidgets.some(clickIsOnWidget)) {
                            // Don't handle clicks when on certain widgets
                        }
                        else {
                            widgets?.forEach(
                                (w) => {
                                    if (!(pos.x > w.x && pos.x < w.x + w.w &&
                                        pos.y > w.y && pos.y < w.y + w.h)) {
                                        App.closeWindow(w.namespace);
                                    }
                                },
                            );
                        }
                    }
                });
            }).catch(print);
        }).catch(print);
    }
}

export default new Pointers();

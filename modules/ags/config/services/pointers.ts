const Hyprland = await Service.import('hyprland');
const { subprocess } = Utils;

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
import { PopupWindow } from 'global-types';
import { Subprocess } from 'types/@girs/gio-2.0/gio-2.0.cjs';
interface Layer {
    address: string
    x: number
    y: number
    w: number
    h: number
    namespace: string
}
interface Levels {
    0?: Layer[] | null
    1?: Layer[] | null
    2?: Layer[] | null
    3?: Layer[] | null
}
interface Layers {
    levels: Levels
}
interface CursorPos {
    x: number
    y: number
}


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

    #process = null as Subprocess | null;
    #lastLine = '';
    #pointers = [] as string[];

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
                (App.windows as PopupWindow[]).some((w) => {
                    const closable = w.close_on_unfocus &&
                      !(
                          w.close_on_unfocus === 'none' ||
                          w.close_on_unfocus === 'stay'
                      );

                    return w.visible && closable;
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
        const toClose = ((App.windows as PopupWindow[])).some((w) => {
            const closable = (
                w.close_on_unfocus &&
                w.close_on_unfocus === clickStage
            );

            return w.visible && closable;
        });

        if (!toClose) {
            return;
        }

        Hyprland.messageAsync('j/layers').then((response) => {
            const layers = JSON.parse(response) as { Layers: Layers };

            Hyprland.messageAsync('j/cursorpos').then((res) => {
                const pos = JSON.parse(res) as CursorPos;

                Object.values(layers).forEach((key) => {
                    const overlayLayer = key.levels['3'];

                    if (overlayLayer) {
                        const noCloseWidgetsNames = [
                            'bar-',
                            'osk',
                        ];

                        const getNoCloseWidgets = (names: string[]) => {
                            const arr = [] as Layer[];

                            names.forEach((name) => {
                                arr.push(
                                    overlayLayer.find(
                                        (n) => n.namespace.startsWith(name),
                                    ) ||
                                    // Return an empty Layer if widget doesn't exist
                                    {
                                        address: '',
                                        x: 0,
                                        y: 0,
                                        w: 0,
                                        h: 0,
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
                            let window = null as null | PopupWindow;

                            if (App.windows.some((win) =>
                                win.name === n.namespace)) {
                                window = (App
                                    .getWindow(n.namespace) as PopupWindow);
                            }

                            return window &&
                              window.close_on_unfocus &&
                              window.close_on_unfocus ===
                              clickStage;
                        });

                        if (noCloseWidgets.some(clickIsOnWidget)) {
                            // Don't handle clicks when on certain widgets
                        }
                        else {
                            widgets.forEach(
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

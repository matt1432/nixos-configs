import App from 'resource:///com/github/Aylur/ags/app.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Service from 'resource:///com/github/Aylur/ags/service.js';

import { subprocess } from 'resource:///com/github/Aylur/ags/utils.js';

const { GUdev } = imports.gi;

const UDEV_POINTERS = [
    'ID_INPUT_MOUSE',
    'ID_INPUT_POINTINGSTICK',
    'ID_INPUT_TOUCHPAD',
    'ID_INPUT_TOUCHSCREEN',
    'ID_INPUT_TABLET',
];
const ON_RELEASE_TRIGGERS = [
    'released',
    'TOUCH_UP',
    'HOLD_END',
];
const ON_CLICK_TRIGGERS = [
    'pressed',
    'TOUCH_DOWN',
];


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

    /** @type typeof imports.gi.Gio.Subprocess */
    #process;
    #lastLine = '';
    /** @type Array<string> */
    #pointers = [];
    #udevClient = GUdev.Client.new(['input']);

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
        this.#initUdevConnection();
        this.#initAppConnection();
    }

    // FIXME: logitech mouse screws everything up on disconnect
    #initUdevConnection() {
        this.#getDevices();
        this.#udevClient.connect('uevent',
            /**
             * @param {typeof imports.gi.GUdev.Client} _
             * @param {string} action
             */
            (_, action) => {
                if (action === 'add' || action === 'remove') {
                    this.#getDevices();
                    if (this.#process) {
                        this.killProc();
                        this.startProc();
                    }
                }
            });
    }

    #getDevices() {
        this.#pointers = [];
        this.#udevClient.query_by_subsystem('input').forEach(
            /** @param {typeof imports.gi.GUdev.Device} dev */
            (dev) => {
                const isPointer = UDEV_POINTERS.some(
                    (p) => dev.has_property(p),
                );

                if (isPointer) {
                    const hasEventFile = dev.has_property('DEVNAME') &&
                                     dev.get_property('DEVNAME')
                                         .includes('event');

                    if (hasEventFile) {
                        this.#pointers.push(dev.get_property('DEVNAME'));
                    }
                }
            },
        );

        this.emit('device-fetched', true);
    }

    startProc() {
        if (this.#process) {
            return;
        }

        const args = [];

        this.#pointers.forEach((dev) => {
            args.push('--device');
            args.push(dev);
        });

        this.#process = subprocess(
            ['libinput', 'debug-events', ...args],
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
            const anyVisibleAndClosable = Array.from(App.windows).some((w) => {
                // @ts-expect-error
                const closable = w[1].attribute?.close_on_unfocus &&
                                // @ts-expect-error
                                !(w[1].attribute?.close_on_unfocus === 'none' ||
                                // @ts-expect-error
                                w[1].attribute?.close_on_unfocus === 'stay');

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

    /** @param {string} clickStage */
    static detectClickedOutside(clickStage) {
        const toClose = Array.from(App.windows).some((w) => {
            // @ts-expect-error
            const closable = (w[1].attribute?.close_on_unfocus &&
                              // @ts-expect-error
                              w[1].attribute?.close_on_unfocus === clickStage);

            return w[1].visible && closable;
        });

        if (!toClose) {
            return;
        }

        Hyprland.sendMessage('j/layers').then((response) => {
            // /** @type import('types/service/hyprland').Layer */
            const layers = JSON.parse(response);

            Hyprland.sendMessage('j/cursorpos').then((res) => {
                const pos = JSON.parse(res);

                Object.values(layers).forEach((key) => {
                    const bar = key.levels['3'].find(
                        /** @param {{ namespace: string }} n */
                        (n) => n.namespace === 'bar',
                    );

                    const widgets = key.levels['3'].filter(
                        /** @param {{ namespace: string }} n */
                        (n) => {
                            const window = App.getWindow(n.namespace);

                        // @ts-expect-error
                            return window?.attribute?.close_on_unfocus &&
                               // @ts-expect-error
                               window?.attribute
                                   ?.close_on_unfocus === clickStage;
                        },
                    );

                    if (pos.x > bar?.x && pos.x < bar?.x + bar?.w &&
                        pos.y > bar?.y && pos.y < bar?.y + bar?.h) {

                        // Don't handle clicks when on bar
                        // TODO: make this configurable
                    }
                    else {
                        widgets.forEach(
                            /** @param {{
                             *      namespace: string
                             *      x: number
                             *      y: number
                             *      h: number
                             *      w: number
                             * }} w
                             */
                            (w) => {
                                if (!(pos.x > w.x && pos.x < w.x + w.w &&
                                  pos.y > w.y && pos.y < w.y + w.h)) {
                                    App.closeWindow(w.namespace);
                                }
                            },
                        );
                    }
                });
            }).catch(print);
        }).catch(print);
    }
}

export default new Pointers();

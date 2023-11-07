import App     from 'resource:///com/github/Aylur/ags/app.js';
import Service from 'resource:///com/github/Aylur/ags/service.js';
import { execAsync, subprocess } from 'resource:///com/github/Aylur/ags/utils.js';
import GUdev from 'gi://GUdev';

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

    proc = undefined;
    output = '';
    devices = [];
    udevClient = GUdev.Client.new(['input']);

    get process()  { return this.proc; }
    get lastLine() { return this.output; }
    get pointers() { return this.devices; }

    constructor() {
        super();
        this.initUdevConnection();
        this.initAppConnection();
    }

    // FIXME: logitech mouse screws everything up on disconnect
    initUdevConnection() {
        this.getDevices();
        this.udevClient.connect('uevent', (_, action) => {
            if (action === 'add' || action === 'remove') {
                this.getDevices();
                if (this.proc) {
                    this.killProc();
                    this.startProc();
                }
            }
        });
    }

    getDevices() {
        this.devices = [];
        this.udevClient.query_by_subsystem('input').forEach(dev => {
            const isPointer = UDEV_POINTERS.some(p => dev.has_property(p));
            if (isPointer) {
                const hasEventFile = dev.has_property('DEVNAME') &&
                                     dev.get_property('DEVNAME').includes('event');
                if (hasEventFile)
                    this.devices.push(dev.get_property('DEVNAME'));
            }
        });

        this.emit('device-fetched', true);
    }

    startProc() {
        if (this.proc)
            return;

        const args = [];
        this.devices.forEach(dev => {
            args.push('--device');
            args.push(dev);
        });

        this.proc = subprocess(
            ['libinput', 'debug-events', ...args],
            output => {
                if (output.includes('cancelled'))
                    return;

                if (ON_RELEASE_TRIGGERS.some(p => output.includes(p))) {
                    this.output = output;
                    this.detectClickedOutside('released');
                    this.emit('released', output);
                    this.emit('new-line', output);
                }

                if (ON_CLICK_TRIGGERS.some(p => output.includes(p))) {
                    this.output = output;
                    this.detectClickedOutside('clicked');
                    this.emit('clicked', output);
                    this.emit('new-line', output);
                }
            },
            err => logError(err),
        );
        this.emit('proc-started', true);
    }

    killProc() {
        if (this.proc) {
            this.proc.force_exit();
            this.proc = undefined;
            this.emit('proc-destroyed', true);
        }
    }

    initAppConnection() {
        App.connect('window-toggled', () => {
            const anyVisibleAndClosable = Array.from(App.windows).some(w => {
                const closable = w[1].closeOnUnfocus &&
                                !(w[1].closeOnUnfocus === 'none' ||
                                    w[1].closeOnUnfocus === 'stay');

                return w[1].visible && closable;
            });

            if (anyVisibleAndClosable)
                this.startProc();

            else
                this.killProc();
        });
    }

    detectClickedOutside(clickStage) {
        const toClose = Array.from(App.windows).some(w => {
            const closable = (w[1].closeOnUnfocus &&
                              w[1].closeOnUnfocus === clickStage);

            return w[1].visible && closable;
        });
        if (!toClose)
            return;

        execAsync('hyprctl layers -j').then(layers => {
            layers = JSON.parse(layers);

            execAsync('hyprctl cursorpos -j').then(pos => {
                pos = JSON.parse(pos);

                Object.values(layers).forEach(key => {
                    const bar = key['levels']['3']
                        .find(n => n.namespace === 'bar');

                    const widgets = key['levels']['3'].filter(n => {
                        const window = App.getWindow(n.namespace);
                        return window.closeOnUnfocus &&
                               window.closeOnUnfocus === clickStage;
                    });

                    if (pos.x > bar.x && pos.x < bar.x + bar.w &&
                        pos.y > bar.y && pos.y < bar.y + bar.h) {

                        // don't handle clicks when on bar
                        // TODO: make this configurable
                    }
                    else {
                        widgets.forEach(w => {
                            if (!(pos.x > w.x && pos.x < w.x + w.w &&
                                  pos.y > w.y && pos.y < w.y + w.h))
                                App.closeWindow(w.namespace);
                        });
                    }
                });
            }).catch(print);
        }).catch(print);
    }
}

const pointersService = new Pointers();
export default pointersService;

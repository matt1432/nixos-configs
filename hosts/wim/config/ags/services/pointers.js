import { Service, Utils } from '../imports.js';
import GUdev from 'gi://GUdev';

const UDEV_POINTERS = [
    'ID_INPUT_MOUSE',
    'ID_INPUT_POINTINGSTICK',
    'ID_INPUT_TOUCHPAD',
    'ID_INPUT_TOUCHSCREEN',
    'ID_INPUT_TABLET',
];
const LIB_POINTERS = [
    'BTN',
    'released',
    'TOUCH_UP',
    'HOLD_END',
];


class Pointers extends Service {
    static {
        Service.register(this, {
            'proc-started': ['boolean'],
            'proc-destroyed': ['boolean'],
            'device-fetched': ['boolean'],
            'new-line': ['string'],
        });
    }

    proc = undefined;
    output = '';
    devices = [];
    udevClient = GUdev.Client.new(['input']);

    get process() { return this.proc; }
    get lastLine() { return this.output; }
    get pointers() { return this.devices; }

    constructor() {
        super();
        this.initUdevConnection();
    }

    // FIXME: logitech mouse screws everything up on disconnect
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

    startProc() {
        if (this.proc)
            return;

        const args = [];
        this.devices.forEach(dev => {
            args.push('--device');
            args.push(dev);
        });

        this.proc = Utils.subprocess(
            ['libinput', 'debug-events', ...args],
            output => {
                if (!output.includes('cancelled')) {
                    if (LIB_POINTERS.some(p => output.includes(p))) {
                        this.output = output;
                        this.emit('new-line', output);
                    }
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
}

const pointersService = new Pointers();
export default pointersService;

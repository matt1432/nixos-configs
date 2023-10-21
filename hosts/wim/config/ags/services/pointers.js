// TODO: read /dev to recalculate devices and remake subprocess

import { Service, Utils } from '../imports.js';


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
    devices = new Map();

    get process() { return this.proc; }
    get lastLine() { return this.output; }
    get pointers() { return this.devices; }

    constructor() {
        super();
        this.parseDevices();
    }

    parseDevices() {
        Utils.execAsync(['libinput', 'list-devices']).then(out => {
            const lines = out.split('\n');
            let device = null;
            const devices = new Map();

            lines.forEach(line => {
                const parts = line.split(':');

                if (parts[0] === 'Device') {
                    device = {};
                    devices.set(parts[1].trim(), device);
                }
                else if (device && parts[1]) {
                    const key = parts[0].trim();
                    const value = parts[1].trim();
                    device[key] = value;
                }
            });
            this.devices = Array.from(devices).filter(dev => dev.Capabilities &&
                                                dev.Capabilities.includes('pointer'));
            this.emit('device-fetched', true);
        }).catch(print);
    }

    startProc() {
        if (this.proc)
            return;

        const args = [];
        this.devices.forEach(dev => {
            if (dev.Kernel) {
                args.push('--device');
                args.push(dev.Kernel);
            }
        });

        this.proc = Utils.subprocess(
            ['libinput', 'debug-events', ...args],
            output => {
                if (output.includes('BTN') && output.includes('released') ||
            output.includes('TOUCH_UP') ||
            output.includes('HOLD_END') && !output.includes('cancelled')) {
                    this.output = output;
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
}

const pointersService = new Pointers();
export default pointersService;

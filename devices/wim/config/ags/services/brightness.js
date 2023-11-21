import Service from 'resource:///com/github/Aylur/ags/service.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

const KBD = 'tpacpi::kbd_backlight';
const CAPS = 'input0::capslock';
const INTERVAL = 500;

class Brightness extends Service {
    static {
        Service.register(this, {
            screen: ['float'],
            kbd: ['float'],
            caps: ['int'],
        });
    }

    #kbd = 0;
    #screen = 0;
    #caps = 0;

    get kbd() {
        return this.#kbd;
    }

    get screen() {
        return this.#screen;
    }

    get caps() {
        return this.#caps;
    }

    set kbd(value) {
        this.#kbd = value;
        // TODO
    }

    set screen(percent) {
        if (percent < 0) {
            percent = 0;
        }

        if (percent > 1) {
            percent = 1;
        }

        execAsync(`brightnessctl s ${percent * 100}% -q`)
            .then(() => {
                this.#screen = percent;
                this.emit('screen', this.#screen);
            })
            .catch(console.error);
    }

    constructor() {
        super();
        try {
            this.#monitorKbdState();
            this.#caps = Number(exec(`brightnessctl -d ${CAPS} g`));
            this.#screen = Number(exec('brightnessctl g')) /
                Number(exec('brightnessctl m'));
        }
        catch (error) {
            console.error('missing dependancy: brightnessctl');
        }
    }

    fetchCapsState() {
        execAsync(`brightnessctl -d ${CAPS} g`)
            .then((out) => {
                this.#caps = out;
                this.emit('caps', this.#caps);
            })
            .catch(logError);
    }

    #monitorKbdState() {
        Variable(0, {
            poll: [INTERVAL, `brightnessctl -d ${KBD} g`, (out) => {
                if (out !== this.#kbd) {
                    this.#kbd = out;
                    this.emit('kbd', this.#kbd);
                }
            }],
        });
    }
}

const brightnessService = new Brightness();

export default brightnessService;

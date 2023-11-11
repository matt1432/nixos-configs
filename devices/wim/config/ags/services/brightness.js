import Service from 'resource:///com/github/Aylur/ags/service.js';
import { exec, execAsync, readFileAsync } from 'resource:///com/github/Aylur/ags/utils.js';

const KBD = 'tpacpi::kbd_backlight';
const CAPS = '/sys/class/leds/input0::capslock/brightness';

class Brightness extends Service {
    static {
        Service.register(this, {
            'screen': ['float'],
            'kbd': ['int'],
            'caps': ['int'],
        });
    }

    _kbd = 0;
    _screen = 0;
    _caps = 0;

    get kbd() { return this._kbd; }
    get screen() { return this._screen; }
    get caps() { return this._caps; }

    set kbd(value) {
        // TODO
    }

    set screen(percent) {
        if (percent < 0)
            percent = 0;

        if (percent > 1)
            percent = 1;

        execAsync(`brightnessctl s ${percent * 100}% -q`)
            .then(() => {
                this._screen = percent;
                this.emit('screen', this._screen);
            })
            .catch(console.error);
    }

    constructor() {
        super();
        try {
            this._kbd = Number(exec(`brightnessctl -d ${KBD} g`));
            this._kbdMax = Number(exec(`brightnessctl -d ${KBD} m`));
            this._screen = Number(exec('brightnessctl g')) / Number(exec('brightnessctl m'));
        } catch (error) {
            console.error('missing dependancy: brightnessctl');
        }
    }

    fetchCapsState() {
        readFileAsync(CAPS)
            .then(out => {
                this._caps = out;
                this.emit('caps', this._caps);
            })
            .catch(logError);
    }
}

const brightnessService = new Brightness();
export default brightnessService;

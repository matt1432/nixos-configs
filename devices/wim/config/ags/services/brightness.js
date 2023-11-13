import Service  from 'resource:///com/github/Aylur/ags/service.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

const KBD = 'tpacpi::kbd_backlight';
const CAPS = 'input0::capslock';

class Brightness extends Service {
    static {
        Service.register(this, {
            'screen': ['float'],
            'kbd': ['float'],
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
            this.monitorKbdState();
            this._caps = Number(exec(`brightnessctl -d ${CAPS} g`));
            this._screen = Number(exec('brightnessctl g')) / Number(exec('brightnessctl m'));
        } catch (error) {
            console.error('missing dependancy: brightnessctl');
        }
    }

    fetchCapsState() {
        execAsync(`brightnessctl -d ${CAPS} g`)
            .then(out => {
                this._caps = out;
                this.emit('caps', this._caps);
            })
            .catch(logError);
    }

    monitorKbdState() {
        Variable(0, {
            poll: [500, `brightnessctl -d ${KBD} g`, out => {
                if (out !== this._kbd) {
                    this._kbd = out;
                    this.emit('kbd', this._kbd);
                }
            }],
        });
    }
}

const brightnessService = new Brightness();
export default brightnessService;

import Service from 'resource:///com/github/Aylur/ags/service.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

const KBD = 'tpacpi::kbd_backlight';
const CAPS = 'input0::capslock';
const INTERVAL = 500;
const SCREEN_ICONS = {
    90: 'display-brightness-high-symbolic',
    70: 'display-brightness-medium-symbolic',
    20: 'display-brightness-low-symbolic',
    5: 'display-brightness-off-symbolic',
};

class Brightness extends Service {
    static {
        Service.register(this, {
            screen: ['float'],
            kbd: ['float'],
            caps: ['int'],
        }, {
            'screen-icon': ['string', 'rw'],
            'caps-icon': ['string', 'rw'],
        });
    }

    #kbd = 0;
    #kbdMax = 0;
    #screen = 0;
    #screenIcon = 'display-brightness-symbolic';
    #caps = 0;
    #capsIcon = 'caps-lock-symbolic';

    get kbd() {
        return this.#kbd;
    }

    get screen() {
        return this.#screen;
    }

    get screenIcon() {
        return this.#screenIcon;
    }

    get caps() {
        return this.#caps;
    }

    get capsIcon() {
        return this.#capsIcon;
    }

    set kbd(value) {
        if (value < 0 || value > this.#kbdMax) {
            return;
        }

        execAsync(`brightnessctl -d ${KBD} s ${value} -q`)
            .then(() => {
                this.#kbd = value;
                this.emit('kbd', this.#kbd);
            })
            .catch(console.error);
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
                this.#getScreenIcon();
                this.emit('screen', this.#screen);
            })
            .catch(console.error);
    }

    constructor() {
        super();
        try {
            this.#monitorKbdState();
            this.#kbdMax = Number(exec(`brightnessctl -d ${KBD} m`));
            this.#caps = Number(exec(`brightnessctl -d ${CAPS} g`));
            this.#screen = Number(exec('brightnessctl g')) /
                Number(exec('brightnessctl m'));
        }
        catch (error) {
            console.error('missing dependancy: brightnessctl');
        }
    }

    #getScreenIcon() {
        const brightness = this.#screen * 100;

        // eslint-disable-next-line
        for (const threshold of [4, 19, 69, 89]) {
            if (brightness > threshold + 1) {
                this.#screenIcon = SCREEN_ICONS[threshold + 1];
                this.notify('screen-icon');
            }
        }
    }

    fetchCapsState() {
        execAsync(`brightnessctl -d ${CAPS} g`)
            .then((out) => {
                this.#caps = Number(out);
                this.#capsIcon = this.#caps ?
                    'caps-lock-symbolic' :
                    'capslock-disabled-symbolic';

                this.notify('caps-icon');
                this.emit('caps', this.#caps);
            })
            .catch(logError);
    }

    #monitorKbdState() {
        Variable(0, {
            poll: [
                INTERVAL,
                `brightnessctl -d ${KBD} g`,
                (out) => {
                    if (parseInt(out) !== this.#kbd) {
                        this.#kbd = parseInt(out);
                        this.emit('kbd', this.#kbd);

                        return this.#kbd;
                    }
                },
            ],
        });
    }
}

const brightnessService = new Brightness();

export default brightnessService;

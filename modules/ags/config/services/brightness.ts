const { exec, execAsync } = Utils;

const KBD = 'tpacpi::kbd_backlight';
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
    #capsName = 'input0::capslock';
    #caps = 0;
    #capsIcon = 'caps-lock-symbolic';

    get capsName() {
        return this.#capsName;
    }

    set capsName(value: string) {
        this.#capsName = value;
    }

    get kbd() {
        return this.#kbd;
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

    get screen() {
        return this.#screen;
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

    get screenIcon() {
        return this.#screenIcon;
    }

    get caps() {
        return this.#caps;
    }

    get capsIcon() {
        return this.#capsIcon;
    }

    constructor() {
        super();
        try {
            this.#monitorKbdState();
            this.#kbdMax = Number(exec(`brightnessctl -d ${KBD} m`));
            this.#caps = Number(exec(`bash -c brightnessctl -d ${this.#capsName} g`));
            this.#screen = Number(exec('brightnessctl g')) / Number(exec('brightnessctl m'));
        }
        catch (_e) {
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
        execAsync(`brightnessctl -d ${this.#capsName} g`)
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
        const interval = setInterval(() => {
            execAsync(`brightnessctl -d ${KBD} g`).then(
                (out) => {
                    if (parseInt(out) !== this.#kbd) {
                        this.#kbd = parseInt(out);
                        this.emit('kbd', this.#kbd);

                        return this.#kbd;
                    }
                },
            ).catch(() => {
                // @ts-expect-error this works in ags
                interval.destroy();
            });
        }, INTERVAL);
    }
}

const brightnessService = new Brightness();

export default brightnessService;

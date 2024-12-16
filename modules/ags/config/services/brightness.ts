import { execAsync, interval } from 'astal';
import GObject, { register, property } from 'astal/gobject';


const SCREEN_ICONS: Record<number, string> = {
    90: 'display-brightness-high-symbolic',
    70: 'display-brightness-medium-symbolic',
    20: 'display-brightness-low-symbolic',
    5: 'display-brightness-off-symbolic',
};

const INTERVAL = 500;

@register()
export default class Brightness extends GObject.Object {
    declare private _kbd: string | undefined;
    declare private _caps: string | undefined;

    declare private _screen: number;

    @property(Number)
    get screen() {
        return this._screen;
    };

    set screen(percent) {
        if (percent < 0) {
            percent = 0;
        }

        if (percent > 1) {
            percent = 1;
        }

        percent = parseFloat(percent.toFixed(2));

        execAsync(`brightnessctl s ${percent * 100}% -q`)
            .then(() => {
                this._screen = percent;
                this.notify('screen');
                this._getScreenIcon();
            })
            .catch(console.error);
    }

    private _screenIcon = 'display-brightness-high-symbolic';

    @property(String)
    get screenIcon() {
        return this._screenIcon;
    }

    public hasKbd = false;
    declare private _kbdMax: number | undefined;
    declare private _kbdLevel: number | undefined;

    @property(Number)
    get kbdLevel() {
        if (!this._kbdMax) {
            console.error('[get kbdLevel] No Keyboard brightness');

            return -1;
        }

        return this._kbdLevel;
    }

    set kbdLevel(value) {
        if (!this._kbdMax || !value) {
            console.error('[set kbdLevel] No Keyboard brightness');

            return;
        }

        if (value < 0 || value > this._kbdMax) {
            return;
        }

        execAsync(`brightnessctl -d ${this._kbd} s ${value} -q`)
            .then(() => {
                this._kbdLevel = value;
                this.notify('kbd-level');
            })
            .catch(console.error);
    }

    declare private _capsLevel: number;

    @property(Number)
    get capsLevel() {
        return this._capsLevel;
    }

    private _capsIcon = 'caps-lock-symbolic';

    @property(String)
    get capsIcon() {
        return this._capsIcon;
    }

    public constructor({ kbd, caps }: { kbd?: string, caps?: string } = {}) {
        super();

        try {
            (async() => {
                if (kbd) {
                    this.hasKbd = true;
                    this._kbd = kbd;
                    this._monitorKbdState();
                    this._kbdMax = Number(await execAsync(`brightnessctl -d ${this._kbd} m`));
                }

                this._caps = caps;
                this._screen = Number(await execAsync('brightnessctl g')) /
                    Number(await execAsync('brightnessctl m'));
                this.notify('screen');
            })();
        }
        catch (_e) {
            console.error('missing dependency: brightnessctl');
        }
    }

    private static _default: InstanceType<typeof Brightness> | undefined;

    public static get_default({ kbd, caps }: { kbd?: string, caps?: string } = {}) {
        if (!Brightness._default) {
            Brightness._default = new Brightness({ kbd, caps });
        }

        return Brightness._default;
    }

    private _getScreenIcon() {
        const brightness = this._screen * 100;

        // eslint-disable-next-line
        for (const threshold of [4, 19, 69, 89]) {
            if (brightness > threshold + 1) {
                this._screenIcon = SCREEN_ICONS[threshold + 1];
                this.notify('screen-icon');
            }
        }
    }

    private _monitorKbdState() {
        const timer = interval(INTERVAL, () => {
            execAsync(`brightnessctl -d ${this._kbd} g`)
                .then(
                    (out) => {
                        if (parseInt(out) !== this._kbdLevel) {
                            this._kbdLevel = parseInt(out);
                            this.notify('kbd-level');
                        }
                    },
                )
                .catch(() => {
                    timer?.cancel();
                });
        });
    }

    public fetchCapsState() {
        execAsync(`brightnessctl -d ${this._caps} g`)
            .then((out) => {
                this._capsLevel = Number(out);
                this._capsIcon = this._capsLevel ?
                    'caps-lock-symbolic' :
                    'capslock-disabled-symbolic';

                this.notify('caps-icon');
                this.notify('caps-level');
            })
            .catch(logError);
    }
}

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
class Brightness extends GObject.Object {
    declare private _kbd: string;
    declare private _caps: string;

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

    declare private _kbdMax: number;
    declare private _kbdLevel: number;

    @property(Number)
    get kbdLevel() {
        return this._kbdLevel;
    }

    set kbdLevel(value) {
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

    /**
     * This is to basically have the constructor run when I want and
     * still export this to wherever I need to.
     *
     * @param o      params
     * @param o.kbd  name of kbd in brightnessctl
     * @param o.caps name of caps_lock in brightnessctl
     */
    public async initService({ kbd = '', caps = '' }) {
        this._kbd = kbd;
        this._caps = caps;
        try {
            this._monitorKbdState();
            this._kbdMax = Number(await execAsync(`brightnessctl -d ${this._kbd} m`));

            this._screen = Number(await execAsync('brightnessctl g')) /
                Number(await execAsync('brightnessctl m'));
            this.notify('screen');
        }
        catch (_e) {
            console.error('missing dependancy: brightnessctl');
        }
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
            execAsync(`brightnessctl -d ${this._kbd} g`).then(
                (out) => {
                    if (parseInt(out) !== this._kbdLevel) {
                        this._kbdLevel = parseInt(out);
                        this.notify('kbd-level');
                    }
                },
            ).catch(() => {
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

const brightnessService = new Brightness();

export default brightnessService;

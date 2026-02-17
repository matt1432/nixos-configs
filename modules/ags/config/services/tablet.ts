import GObject, { getter, register, setter, signal } from 'ags/gobject';
import { execAsync, subprocess } from 'ags/process';

import { hyprMessage } from '../lib';
type RotationName = 'normal' | 'right-up' | 'bottom-up' | 'left-up';

const ROTATION_MAP: Record<RotationName, 0 | 1 | 2 | 3> = {
    normal: 0,
    'right-up': 3,
    'bottom-up': 2,
    'left-up': 1,
};

const SCREEN = 'desc:BOE 0x0964';

const DEVICES = ['wacom-hid-52eb-finger', 'wacom-hid-52eb-pen'];

interface TabletSignals extends GObject.Object.SignalSignatures {
    'autorotate-changed': Tablet['autorotateChanged'];
    'inputs-changed': Tablet['inputsChanged'];
    'notify::current-mode': (val: Tablet['currentMode']) => void;
    'notify::osk-state': (val: Tablet['oskState']) => void;
    'notify::osk-auto-changed': (val: Tablet['oskAutoChanged']) => void;
}

@register()
export default class Tablet extends GObject.Object {
    @signal([Boolean], GObject.TYPE_NONE, { default: false })
    autorotateChanged(running: boolean): undefined {
        console.log(running);
    }

    @signal([Boolean], GObject.TYPE_NONE, { default: false })
    inputsChanged(blocked: boolean): undefined {
        console.log(blocked);
    }

    declare $signals: TabletSignals; // this makes signals inferable in JSX

    override connect<S extends keyof TabletSignals>(
        signal: S,
        callback: GObject.SignalCallback<this, TabletSignals[S]>,
    ): number {
        return super.connect(signal, callback);
    }

    private _currentMode: 'laptop' | 'tablet' = 'laptop';

    @getter(String)
    get currentMode() {
        return this._currentMode;
    }

    @setter(String)
    set currentMode(val) {
        this._currentMode = val;

        if (this._currentMode === 'tablet') {
            execAsync([
                'brightnessctl',
                '-d',
                'tpacpi::kbd_backlight',
                's',
                '0',
            ]).catch(print);

            this.startAutorotate();
            this._blockInputs();
            this._startInputDetection();
        }
        else if (this._currentMode === 'laptop') {
            execAsync([
                'brightnessctl',
                '-d',
                'tpacpi::kbd_backlight',
                's',
                '2',
            ]).catch(print);

            this.killAutorotate();
            this._unblockInputs();
            this._stopInputDetection();
            this.oskState = false;
        }

        this.notify('current-mode');
    }

    private _oskState = false;

    @getter(Boolean)
    get oskState() {
        return this._oskState;
    }

    @setter(Boolean)
    set oskState(val) {
        this._oskState = val;
        // this is set to true after this setter in the request.
        this.oskAutoChanged = false;
        this.notify('osk-state');
    }

    public toggleOsk() {
        this.oskState = !this.oskState;
    }

    private _oskAutoChanged = false;

    @getter(Boolean)
    get oskAutoChanged() {
        return this._oskAutoChanged;
    }

    @setter(Boolean)
    set oskAutoChanged(val) {
        this._oskAutoChanged = val;
    }

    private _inputDetection: ReturnType<typeof subprocess> | null = null;

    private _startInputDetection() {
        if (this._inputDetection) {
            return;
        }

        this._inputDetection = subprocess(
            [
                'fcitx5',
                '--disable',
                'all',
                '--enable',
                'keyboard,virtualkeyboardadapter,wayland,waylandim',
            ],
            () => {},
            () => {},
        );
    }

    private _stopInputDetection() {
        if (this._inputDetection) {
            this._inputDetection.kill();
            this._inputDetection = null;
        }
    }

    private _autorotate: ReturnType<typeof subprocess> | null = null;

    get autorotateState() {
        return this._autorotate !== null;
    }

    private _blockedInputs: ReturnType<typeof subprocess> | null = null;

    private _blockInputs() {
        if (this._blockedInputs) {
            return;
        }

        this._blockedInputs = subprocess(
            [
                'libinput',
                'debug-events',
                '--grab',
                '--device',
                '/dev/input/by-path/platform-i8042-serio-0-event-kbd',
                '--device',
                '/dev/input/by-path/platform-i8042-serio-1-event-mouse',
                '--device',
                '/dev/input/by-path/platform-AMDI0010:02-event-mouse',
                '--device',
                '/dev/input/by-path/platform-thinkpad_acpi-event',
                '--device',
                '/dev/video-bus',
            ],
            () => {},
        );

        this.emit('inputs-changed', true);
    }

    private _unblockInputs() {
        if (this._blockedInputs) {
            this._blockedInputs.kill();
            this._blockedInputs = null;

            this.emit('inputs-changed', false);
        }
    }

    public toggleMode() {
        if (this.currentMode === 'laptop') {
            this.currentMode = 'tablet';
        }
        else if (this.currentMode === 'tablet') {
            this.currentMode = 'laptop';
        }
    }

    public startAutorotate() {
        if (this._autorotate) {
            return;
        }

        this._autorotate = subprocess(['monitor-sensor'], (output) => {
            if (output.includes('orientation changed')) {
                const index = output.split(' ').at(-1) as
                    | RotationName
                    | undefined;

                if (!index) {
                    return;
                }

                const orientation = ROTATION_MAP[index];

                hyprMessage(
                    `keyword monitor ${SCREEN},transform,${orientation}`,
                ).catch(print);

                const batchRotate = DEVICES.map(
                    (dev) => `keyword device:${dev}:transform ${orientation}; `,
                );

                hyprMessage(`[[BATCH]] ${batchRotate.flat()}`);
            }
        });

        this.emit('autorotate-changed', true);
    }

    public killAutorotate() {
        if (this._autorotate) {
            this._autorotate.kill();
            this._autorotate = null;

            this.emit('autorotate-changed', false);
        }
    }

    private static _default: InstanceType<typeof Tablet> | undefined;

    public static get_default() {
        if (!Tablet._default) {
            Tablet._default = new Tablet();
        }

        return Tablet._default;
    }
}

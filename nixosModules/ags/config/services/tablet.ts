import { execAsync, subprocess } from 'astal';
import GObject, { register, property, signal } from 'astal/gobject';

import { hyprMessage } from '../lib';

/* Types */
import AstalIO from 'gi://AstalIO';
type RotationName = 'normal' | 'right-up' | 'bottom-up' | 'left-up';


const ROTATION_MAP: Record<RotationName, 0 | 1 | 2 | 3> = {
    'normal': 0,
    'right-up': 3,
    'bottom-up': 2,
    'left-up': 1,
};

const SCREEN = 'desc:BOE 0x0964';

const DEVICES = [
    'wacom-hid-52eb-finger',
    'wacom-hid-52eb-pen',
];

@register()
export default class Tablet extends GObject.Object {
    @signal(Boolean)
    declare autorotateChanged: (running: boolean) => void;

    @signal(Boolean)
    declare inputsChanged: (blocked: boolean) => void;


    private _currentMode = 'laptop';

    @property(String)
    get currentMode() {
        return this._currentMode;
    }

    set currentMode(val) {
        this._currentMode = val;

        if (this._currentMode === 'tablet') {
            execAsync(['brightnessctl', '-d', 'tpacpi::kbd_backlight', 's', '0'])
                .catch(print);

            this.startAutorotate();
            this._blockInputs();
        }
        else if (this._currentMode === 'laptop') {
            execAsync(['brightnessctl', '-d', 'tpacpi::kbd_backlight', 's', '2'])
                .catch(print);

            this.killAutorotate();
            this._unblockInputs();
        }

        this.notify('current-mode');
    }


    private _oskState = false;

    @property(Boolean)
    get oskState() {
        return this._oskState;
    }

    set oskState(val) {
        this._oskState = val;
        this.notify('osk-state');
    }

    public toggleOsk() {
        this.oskState = !this.oskState;
    }


    private _autorotate = null as AstalIO.Process | null;

    get autorotateState() {
        return this._autorotate !== null;
    }


    private _blockedInputs = null as AstalIO.Process | null;

    private _blockInputs() {
        if (this._blockedInputs) {
            return;
        }

        this._blockedInputs = subprocess(['libinput', 'debug-events', '--grab',
            '--device', '/dev/input/by-path/platform-i8042-serio-0-event-kbd',
            '--device', '/dev/input/by-path/platform-i8042-serio-1-event-mouse',
            '--device', '/dev/input/by-path/platform-AMDI0010:02-event-mouse',
            '--device', '/dev/input/by-path/platform-thinkpad_acpi-event',
            '--device', '/dev/video-bus'],
        () => { /**/ });

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

        this._autorotate = subprocess(
            ['monitor-sensor'],
            (output) => {
                if (output.includes('orientation changed')) {
                    const index = output.split(' ').at(-1) as RotationName | undefined;

                    if (!index) {
                        return;
                    }

                    const orientation = ROTATION_MAP[index];

                    hyprMessage(
                        `keyword monitor ${SCREEN},transform,${orientation}`,
                    ).catch(print);

                    const batchRotate = DEVICES.map((dev) =>
                        `keyword device:${dev}:transform ${orientation}; `);

                    hyprMessage(`[[BATCH]] ${batchRotate.flat()}`);
                }
            },
        );

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

const Hyprland = await Service.import('hyprland');
const { execAsync, subprocess } = Utils;

import TouchGestures from './touch-gestures.ts';

const ROTATION_MAP = {
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

// Types
import { Subprocess } from 'types/@girs/gio-2.0/gio-2.0.cjs';


class Tablet extends Service {
    static {
        Service.register(this, {
            'device-fetched': ['boolean'],
            'autorotate-started': ['boolean'],
            'autorotate-destroyed': ['boolean'],
            'autorotate-toggled': ['boolean'],
            'inputs-blocked': ['boolean'],
            'inputs-unblocked': ['boolean'],
            'laptop-mode': ['boolean'],
            'tablet-mode': ['boolean'],
            'mode-toggled': ['boolean'],
            'osk-toggled': ['boolean'],
        });
    }

    #tabletMode = false;
    #oskState = false;
    #autorotate = null as Subprocess | null;
    #blockedInputs = null as Subprocess | null;

    get tabletMode() {
        return this.#tabletMode;
    }

    get autorotateState() {
        return this.#autorotate !== null;
    }

    get oskState() {
        return this.#oskState;
    }

    set oskState(value: boolean) {
        this.#oskState = value;
        this.emit('osk-toggled', this.#oskState);
    }

    #blockInputs() {
        if (this.#blockedInputs) {
            return;
        }

        this.#blockedInputs = subprocess(['libinput', 'debug-events', '--grab',
            '--device', '/dev/input/by-path/platform-i8042-serio-0-event-kbd',
            '--device', '/dev/input/by-path/platform-i8042-serio-1-event-mouse',
            '--device', '/dev/input/by-path/platform-AMDI0010:02-event-mouse',
            '--device', '/dev/input/by-path/platform-thinkpad_acpi-event',
            '--device', '/dev/video-bus'],
        () => { /**/ });
        this.emit('inputs-blocked', true);
    }

    #unblockInputs() {
        if (this.#blockedInputs) {
            this.#blockedInputs.force_exit();
            this.#blockedInputs = null;
            this.emit('inputs-unblocked', true);
        }
    }

    setTabletMode() {
        execAsync(['brightnessctl', '-d', 'tpacpi::kbd_backlight', 's', '0'])
            .catch(print);

        this.startAutorotate();
        this.#blockInputs();

        this.#tabletMode = true;
        this.emit('tablet-mode', true);
        this.emit('mode-toggled', true);
    }

    setLaptopMode() {
        execAsync(['brightnessctl', '-d', 'tpacpi::kbd_backlight', 's', '2'])
            .catch(print);

        this.killAutorotate();
        this.#unblockInputs();

        this.#tabletMode = false;
        this.emit('laptop-mode', true);
        this.emit('mode-toggled', true);
    }

    toggleMode() {
        if (this.#tabletMode) {
            this.setLaptopMode();
        }
        else {
            this.setTabletMode();
        }

        this.emit('mode-toggled', true);
    }

    startAutorotate() {
        if (this.#autorotate) {
            return;
        }

        this.#autorotate = subprocess(
            ['monitor-sensor'],
            (output) => {
                if (output.includes('orientation changed')) {
                    const index = output.split(' ').at(-1);

                    if (!index) {
                        return;
                    }

                    const orientation = ROTATION_MAP[index];

                    Hyprland.messageAsync(
                        `keyword monitor ${SCREEN},transform,${orientation}`,
                    ).catch(print);

                    const batchRotate = DEVICES.map((dev) =>
                        `keyword device:${dev}:transform ${orientation}; `);

                    Hyprland.messageAsync(`[[BATCH]] ${batchRotate.flat()}`);

                    if (TouchGestures.gestureDaemon) {
                        TouchGestures.killDaemon();
                        TouchGestures.startDaemon();
                    }
                }
            },
        );
        this.emit('autorotate-started', true);
        this.emit('autorotate-toggled', true);
    }

    killAutorotate() {
        if (this.#autorotate) {
            this.#autorotate.force_exit();
            this.#autorotate = null;
            this.emit('autorotate-destroyed', true);
            this.emit('autorotate-toggled', false);
        }
    }

    toggleOsk() {
        this.#oskState = !this.#oskState;
        this.emit('osk-toggled', this.#oskState);
    }
}

const tabletService = new Tablet();

export default tabletService;

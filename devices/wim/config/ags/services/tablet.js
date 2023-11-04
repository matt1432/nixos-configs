import Service from 'resource:///com/github/Aylur/ags/service.js';
import { execAsync, subprocess } from 'resource:///com/github/Aylur/ags/utils.js';
import GUdev from 'gi://GUdev';

const ROTATION_MAPPING = {
    'normal': 0,
    'right-up': 3,
    'bottom-up': 2,
    'left-up': 1,
};
const SCREEN = 'desc:BOE 0x0964';


// TODO: Make autorotate reset lisgd
class Tablet extends Service {
    static {
        Service.register(this, {
            'device-fetched': ['boolean'],
            'autorotate-started': ['boolean'],
            'autorotate-destroyed': ['boolean'],
            'inputs-blocked': ['boolean'],
            'inputs-unblocked': ['boolean'],
            'laptop-mode': ['boolean'],
            'tablet-mode': ['boolean'],
            'mode-toggled': ['boolean'],
            'osk-toggled': ['boolean'],
        });
    }

    tabletMode = false;
    autorotate = undefined;
    oskState = false;
    blockedInputs = undefined;
    udevClient = GUdev.Client.new(['input']);

    get tabletMode() { return this.tabletMode; }
    get autorotate() { return this.autorotate; }

    constructor() {
        super();
        this.initUdevConnection();
        this.listenOskState();
    }

    blockInputs() {
        if (this.blockedInputs)
            return;

        this.blockedInputs = subprocess(['libinput', 'debug-events', '--grab',
            '--device', '/dev/input/by-path/platform-i8042-serio-0-event-kbd',
            '--device', '/dev/input/by-path/platform-i8042-serio-1-event-mouse',
            '--device', '/dev/input/by-path/platform-AMDI0010:02-event-mouse',
            '--device', '/dev/input/by-path/platform-thinkpad_acpi-event',
            '--device', '/dev/video-bus',
            '--device', '/dev/touchpad',
        ],
        () => {},
        err => logError(err));
        this.emit('inputs-blocked', true);
    }

    unblockInputs() {
        if (this.blockedInputs) {
            this.blockedInputs.force_exit();
            this.blockedInputs = undefined;
            this.emit('inputs-unblocked', true);
        }
    }

    setTabletMode() {
        execAsync(['gsettings', 'set', 'org.gnome.desktop.a11y.applications',
            'screen-keyboard-enabled', 'true']).catch(print);

        execAsync(['brightnessctl', '-d', 'tpacpi::kbd_backlight', 's', '0'])
            .catch(print);

        this.startAutorotate();
        this.blockInputs();

        this.tabletMode = true;
        this.emit('tablet-mode', true);
        this.emit('mode-toggled', true);
    }

    setLaptopMode() {
        execAsync(['gsettings', 'set', 'org.gnome.desktop.a11y.applications',
            'screen-keyboard-enabled', 'false']).catch(print);

        execAsync(['brightnessctl', '-d', 'tpacpi::kbd_backlight', 's', '2'])
            .catch(print);

        this.killAutorotate();
        this.unblockInputs();

        this.tabletMode = false;
        this.emit('laptop-mode', true);
        this.emit('mode-toggled', true);
    }

    toggleMode() {
        if (this.tabletMode)
            this.setLaptopMode();
        else
            this.setTabletMode();

        this.emit('mode-toggled', true);
    }

    initUdevConnection() {
        this.getDevices();
        this.udevClient.connect('uevent', (_, action) => {
            if (action === 'add' || action === 'remove')
                this.getDevices();
        });
    }

    getDevices() {
        this.devices = [];
        execAsync(['hyprctl', 'devices', '-j']).then(out => {
            const devices = JSON.parse(out);
            devices['touch'].forEach(dev => {
                this.devices.push(dev.name);
            });
            devices['tablets'].forEach(dev => {
                this.devices.push(dev.name);
            });
        }).catch(print);

        this.emit('device-fetched', true);
    }

    startAutorotate() {
        if (this.autorotate)
            return;

        this.autorotate = subprocess(
            ['monitor-sensor'],
            output => {
                if (output.includes('orientation changed')) {
                    const orientation = ROTATION_MAPPING[output.split(' ').at(-1)];

                    execAsync(['hyprctl', 'keyword', 'monitor',
                        `${SCREEN},transform,${orientation}`]).catch(print);

                    this.devices.forEach(dev => {
                        execAsync(['hyprctl', 'keyword',
                            `device:"${dev}":transform`, String(orientation)]).catch(print);
                    });
                }
            },
            err => logError(err),
        );
        this.emit('autorotate-started', true);
    }

    killAutorotate() {
        if (this.autorotate) {
            this.autorotate.force_exit();
            this.autorotate = undefined;
            this.emit('autorotate-destroyed', true);
        }
    }

    listenOskState() {
        subprocess(
            ['bash', '-c', 'busctl monitor --user sm.puri.OSK0'],
            output => {
                if (output.includes('BOOLEAN')) {
                    this.oskState = output.match('true|false')[0] === 'true';
                    this.emit('osk-toggled', this.oskState);
                }
            },
            err => logError(err),
        );
    }

    openOsk() {
        execAsync(['busctl', 'call', '--user',
            'sm.puri.OSK0', '/sm/puri/OSK0', 'sm.puri.OSK0',
            'SetVisible', 'b', 'true'])
            .catch(print);
    }

    closeOsk() {
        execAsync(['busctl', 'call', '--user',
            'sm.puri.OSK0', '/sm/puri/OSK0', 'sm.puri.OSK0',
            'SetVisible', 'b', 'false'])
            .catch(print);
    }

    toggleOsk() {
        if (this.oskState)
            this.closeOsk();
        else
            this.openOsk();
    }
}

const tabletService = new Tablet();
export default tabletService;

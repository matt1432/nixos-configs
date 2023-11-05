import Service from 'resource:///com/github/Aylur/ags/service.js';
import { subprocess } from 'resource:///com/github/Aylur/ags/utils.js';

const SCREEN = '/dev/input/by-path/platform-AMDI0010\:00-event';

const GESTURE_VERIF = [
    'LR', // Left to Right
    'RL', // Right to Left
    'DU', // Down to Up
    'UD', // Up to Down
    'DLUR', // Down to Left to Up to Right (clockwise motion from Down)
    'DRUL', // Down to Right to Up to Left (counter-clockwise from Down)
    'URDL', // Up to Right to Down to Left (clockwise motion from Up)
    'ULDR', // Up to Left to Down to Right (counter-clockwise from Up)
];
const EDGE_VERIF = [
    '*', // any
    'N', // none
    'L', // left
    'R', // right
    'T', // top
    'B', // bottom
    'TL', // top left
    'TR', // top right
    'BL', // bottom left
    'BR', // bottom right
];
const DISTANCE_VERIF = [
    '*', // any
    'S', // short
    'M', // medium
    'L', // large
];


class TouchGestures extends Service {
    static {
        Service.register(this, {
            'daemon-started': ['boolean'],
            'daemon-destroyed': ['boolean'],
        });
    }

    gestures = new Map();
    gestureDaemon = undefined;

    get gestures() { return this.gestures; }

    constructor() {
        super();
    }

    addGesture({
        name,
        nFingers = '1',
        gesture,
        edge = '*',
        distance = '*',
        command,
    } = {}) {
        gesture = String(gesture).toUpperCase();
        if (!GESTURE_VERIF.includes(gesture)) {
            logError('Wrong gesture id');
            return;
        }

        edge = String(edge).toUpperCase();
        if (!EDGE_VERIF.includes(edge)) {
            logError('Wrong edge id');
            return;
        }

        distance = String(distance).toUpperCase();
        if (!DISTANCE_VERIF.includes(distance)) {
            logError('Wrong distance id');
            return;
        }

        this.gestures.set(name, [
            '-g',
            `${nFingers},${gesture},${edge},${distance},${command}`,
        ]);

        if (this.gestureDaemon)
            this.killDaemon();
        this.startDaemon();
    }

    startDaemon() {
        if (this.gestureDaemon)
            return;

        var command = [
            'lisgd', '-d', SCREEN,
            // orientation
            '-o', '0',
            // Threshold of gesture recognized
            '-t', '125',
            // Leniency of gesture angle
            '-r', '25',
            // Timeout time
            '-m', '3200',
        ];

        this.gestures.forEach(gesture => {
            command = command.concat(gesture);
        });

        this.gestureDaemon = subprocess(
            command,
            () => {},
            err => logError(err),
        );
        this.emit('daemon-started', true);
    }

    killDaemon() {
        if (this.gestureDaemon) {
            this.gestureDaemon.force_exit();
            this.gestureDaemon = undefined;
            this.emit('daemon-destroyed', true);
        }
    }
}

const touchGesturesService = new TouchGestures();
export default touchGesturesService;

const { subprocess } = Utils;

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
    '*', // Any
    'N', // None
    'L', // Left
    'R', // Right
    'T', // Top
    'B', // Bottom
    'TL', // Top left
    'TR', // Top right
    'BL', // Bottom left
    'BR', // Bottom right
];
const DISTANCE_VERIF = [
    '*', // Any
    'S', // Short
    'M', // Medium
    'L', // Large
];

// Types
import { Subprocess } from 'types/@girs/gio-2.0/gio-2.0.cjs';


// TODO: add actmode param
// TODO: support multiple daemons for different thresholds
class TouchGestures extends Service {
    static {
        Service.register(this, {
            'daemon-started': ['boolean'],
            'daemon-destroyed': ['boolean'],
        });
    }

    #gestures = new Map();
    #gestureDaemon = null as Subprocess | null;

    get gestures() {
        return this.#gestures;
    }

    get gestureDaemon() {
        return this.#gestureDaemon;
    }

    addGesture({
        name,
        nFingers = '1',
        gesture,
        edge = '*',
        distance = '*',
        command,
    }) {
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

        if (typeof command !== 'string') {
            globalThis[name] = command;
            command = `ags -r "${name}()"`;
        }

        this.#gestures.set(name, [
            '-g',
            `${nFingers},${gesture},${edge},${distance},${command}`,
        ]);

        if (this.#gestureDaemon) {
            this.killDaemon();
        }
        this.startDaemon();
    }

    startDaemon() {
        if (this.#gestureDaemon) {
            return;
        }

        let command = [
            'lisgd', '-d', SCREEN,
            // Orientation
            '-o', '0',
            // Threshold of gesture recognized
            '-t', '125',
            // Leniency of gesture angle
            '-r', '25',
            // Timeout time
            '-m', '3200',
        ];

        this.#gestures.forEach((gesture) => {
            command = command.concat(gesture);
        });

        this.#gestureDaemon = subprocess(
            command,
            () => { /**/ },
        );
        this.emit('daemon-started', true);
    }

    killDaemon() {
        if (this.#gestureDaemon) {
            this.#gestureDaemon.force_exit();
            this.#gestureDaemon = null;
            this.emit('daemon-destroyed', true);
        }
    }
}

const touchGesturesService = new TouchGestures();

export default touchGesturesService;

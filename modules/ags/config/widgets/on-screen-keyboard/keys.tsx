import { Astal, Gtk } from 'ags/gtk3';
import { execAsync } from 'ags/process';
import { interval } from 'ags/time';
import AstalIO from 'gi://AstalIO';
import { Accessor, createState, Setter } from 'gnim';

import { toggleClassName } from '../../lib/widgets';
import Brightness from '../../services/brightness';
import Separator from '../misc/separator';

interface Key {
    keytype: string;
    label: string;
    labelShift?: string;
    labelAltGr?: string;
    shape: string;
    keycode: number;
}

const brightness = Brightness.get_default();

const SPACING = 4;
const LSHIFT_CODE = 42;
const LALT_CODE = 56;
const LCTRL_CODE = 29;

export const [Keys, setKeys] = createState<Accessor<boolean>[]>([]);

// Keep track of modifier statuses
const [Super, setSuper] = createState(false);
const [LAlt, setLAlt] = createState(false);
const [LCtrl, setLCtrl] = createState(false);
const [AltGr, setAltGr] = createState(false);
const [RCtrl, setRCtrl] = createState(false);

const [Caps, setCaps] = createState(false);

brightness.connect('notify::caps-level', (_, state) => {
    setCaps(state);
});

// Assume both shifts are the same for key.labelShift
const [LShift, setLShift] = createState(false);
const [RShift, setRShift] = createState(false);

const [Shift, setShift] = createState(false);

LShift.subscribe(() => {
    setShift(LShift() || RShift());
});
RShift.subscribe(() => {
    setShift(LShift() || RShift());
});

const ModKey = (key: Key) => {
    let Mod: Accessor<boolean>;
    let setMod: Setter<boolean>;

    if (key.label === 'Super') {
        Mod = Super;
        setMod = setSuper;
    }

    // Differentiate left and right mods
    else if (key.label === 'Shift' && key.keycode === LSHIFT_CODE) {
        Mod = LShift;
        setMod = setLShift;
    }
    else if (key.label === 'Alt' && key.keycode === LALT_CODE) {
        Mod = LAlt;
        setMod = setLAlt;
    }
    else if (key.label === 'Ctrl' && key.keycode === LCTRL_CODE) {
        Mod = LCtrl;
        setMod = setLCtrl;
    }
    else if (key.label === 'Shift') {
        Mod = RShift;
        setMod = setRShift;
    }
    else if (key.label === 'AltGr') {
        Mod = AltGr;
        setMod = setAltGr;
    }
    else if (key.label === 'Ctrl') {
        Mod = RCtrl;
        setMod = setRCtrl;
    }

    setKeys([...Keys(), Mod!]);

    const label = (
        <label class={`mod ${key.label}`} label={key.label} />
    ) as Astal.Label;

    const button = (
        <cursor-eventbox
            class="key"
            cursor="pointer"
            onButtonPressEvent={() => {
                execAsync(`ydotool key ${key.keycode}:${Mod() ? 0 : 1}`);

                toggleClassName(label, 'active', !Mod());
                setMod(!Mod());
            }}
        >
            {label}
        </cursor-eventbox>
    );

    return (
        <box>
            {button}
            <Separator size={SPACING} />
        </box>
    ) as Astal.Box;
};

const RegularKey = (key: Key) => {
    const [IsActive, setIsActive] = createState(false);
    const [IsLongPressing, setIsLongPressing] = createState(false);

    setKeys([...Keys(), IsActive]);

    const widget = (
        <cursor-eventbox
            class="key"
            cursor="pointer"
            onButtonReleaseEvent={() => {
                setIsLongPressing(false);
                setIsActive(false);
            }}
        >
            <label
                class={IsActive.as((v) =>
                    ['normal', key.label, v ? 'active' : ''].join(' '),
                )}
                label={key.label}
                $={(self) => {
                    Shift.subscribe(() => {
                        if (key.labelShift) {
                            self.set_label(
                                Shift() ? key.labelShift : key.label,
                            );
                        }
                    });

                    Caps.subscribe(() => {
                        if (key.label === 'Caps') {
                            setIsActive(Caps());

                            return;
                        }

                        if (key.labelShift && key.label.match(/[A-Za-z]/)) {
                            self.set_label(Caps() ? key.labelShift : key.label);
                        }
                    });

                    AltGr.subscribe(() => {
                        if (key.labelAltGr) {
                            toggleClassName(self, 'altgr', AltGr());

                            self.set_label(
                                AltGr() ? key.labelAltGr : key.label,
                            );
                        }
                    });
                }}
            />
        </cursor-eventbox>
    ) as Astal.EventBox;

    const gesture = Gtk.GestureLongPress.new(widget);

    gesture.delay_factor = 1.0;

    const onClick = (callback: () => void) => {
        const pointer = gesture.get_point(null);
        const x = pointer[1];
        const y = pointer[2];

        if (!x || !y || (x === 0 && y === 0)) {
            return;
        }

        callback();
    };

    gesture.connect('begin', () => {
        setIsActive(true);
    });

    gesture.connect('cancelled', () => {
        onClick(() => {
            execAsync(`ydotool key ${key.keycode}:1`);
            execAsync(`ydotool key ${key.keycode}:0`);

            setIsActive(false);
        });
    });

    // Long Press
    gesture.connect('pressed', () => {
        onClick(() => {
            setIsLongPressing(true);
        });
    });

    let spamClick: AstalIO.Time | undefined;

    IsLongPressing.subscribe(() => {
        if (IsLongPressing()) {
            spamClick = interval(100, () => {
                execAsync(`ydotool key ${key.keycode}:1`);
                execAsync(`ydotool key ${key.keycode}:0`);
            });
        }
        else {
            spamClick?.cancel();
        }
    });

    return (
        <box>
            {widget}
            <Separator size={SPACING} />
        </box>
    ) as Astal.Box;
};

export default (key: Key): Astal.Box =>
    key.keytype === 'normal' ? RegularKey(key) : ModKey(key);

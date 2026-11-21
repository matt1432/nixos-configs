import { Gtk } from 'ags/gtk4';
import { execAsync } from 'ags/process';
import { interval, timeout, Timer } from 'ags/time';
import { Accessor, createState, Setter } from 'gnim';

import { pointer, toggleClassName } from '../../lib/widgets';
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

const SPACING = 4;
const LSHIFT_CODE = 42;
const LALT_CODE = 56;
const LCTRL_CODE = 29;

// Same as GTK's default gtk-long-press-time with a delay factor of 1
const LONG_PRESS_DELAY = 500;

export const [Keys, setKeys] = createState<Accessor<boolean>[]>([]);

// Keep track of modifier statuses
const [Super, setSuper] = createState(false);
const [LAlt, setLAlt] = createState(false);
const [LCtrl, setLCtrl] = createState(false);
const [AltGr, setAltGr] = createState(false);
const [RCtrl, setRCtrl] = createState(false);

const [Caps, setCaps] = createState(false);

// Assume both shifts are the same for key.labelShift
const [LShift, setLShift] = createState(false);
const [RShift, setRShift] = createState(false);

const [Shift, setShift] = createState(false);

export const setupKeys = () => {
    const brightness = Brightness.get_default();

    brightness.connect('notify::caps-level', () => {
        setCaps(Boolean(brightness.capsLevel));
    });

    LShift.subscribe(() => {
        setShift(LShift() || RShift());
    });
    RShift.subscribe(() => {
        setShift(LShift() || RShift());
    });
};

/**
 * GTK4 doesn't set the :active state on boxes, so we do it manually
 * to keep the `.key:active` styling.
 *
 * @param widget the key widget
 * @param active whether the key is pressed
 */
const setPressed = (widget: Gtk.Widget, active: boolean) => {
    if (active) {
        widget.set_state_flags(Gtk.StateFlags.ACTIVE, false);
    }
    else {
        widget.unset_state_flags(Gtk.StateFlags.ACTIVE);
    }
};

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
    ) as Gtk.Label;

    const button = (
        <box class="key" cursor={pointer}>
            {label}
        </box>
    ) as Gtk.Box;

    const click = new Gtk.GestureClick();

    click.connect('pressed', () => {
        setPressed(button, true);

        execAsync(`ydotool key ${key.keycode}:${Mod() ? 0 : 1}`);

        toggleClassName(label, 'active', !Mod());
        setMod(!Mod());
    });

    click.connect('end', () => {
        setPressed(button, false);
    });

    button.add_controller(click);

    return (
        <box>
            {button}
            <Separator size={SPACING} />
        </box>
    ) as Gtk.Box;
};

const RegularKey = (key: Key) => {
    const [IsActive, setIsActive] = createState(false);
    const [IsLongPressing, setIsLongPressing] = createState(false);

    setKeys([...Keys(), IsActive]);

    const widget = (
        <box class="key" cursor={pointer}>
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
        </box>
    ) as Gtk.Box;

    const sendKey = () => {
        execAsync(`ydotool key ${key.keycode}:1`);
        execAsync(`ydotool key ${key.keycode}:0`);
    };

    /*
     * A short press sends the key once on release, while holding the key
     * for longer than LONG_PRESS_DELAY repeats it until it is released.
     */
    const click = new Gtk.GestureClick();

    let longPressTimer: Timer | undefined;
    let clickPending = false;

    click.connect('pressed', () => {
        clickPending = true;
        setPressed(widget, true);
        setIsActive(true);

        longPressTimer?.cancel();
        longPressTimer = timeout(LONG_PRESS_DELAY, () => {
            longPressTimer = undefined;
            clickPending = false;
            setIsLongPressing(true);
        });
    });

    click.connect('released', () => {
        if (clickPending) {
            clickPending = false;
            sendKey();
        }
    });

    click.connect('end', () => {
        longPressTimer?.cancel();
        longPressTimer = undefined;

        setPressed(widget, false);
        setIsLongPressing(false);
        setIsActive(false);
    });

    widget.add_controller(click);

    let spamClick: Timer | undefined;

    IsLongPressing.subscribe(() => {
        if (IsLongPressing()) {
            spamClick = interval(100, sendKey);
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
    ) as Gtk.Box;
};

export const Key = (key: Key): Gtk.Box =>
    key.keytype === 'normal' ? RegularKey(key) : ModKey(key);

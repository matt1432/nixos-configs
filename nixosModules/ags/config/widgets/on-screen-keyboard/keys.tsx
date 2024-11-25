import { execAsync, Variable } from 'astal';
import { Gdk, Gtk, Widget } from 'astal/gtk3';

import Brightness from '../../services/brightness';

import Separator from '../misc/separator';

/* Types */
interface Key {
    keytype: string
    label: string
    labelShift?: string
    labelAltGr?: string
    shape: string
    keycode: number
}


const display = Gdk.Display.get_default();
const brightness = Brightness.get_default();

const SPACING = 4;
const LSHIFT_CODE = 42;
const LALT_CODE = 56;
const LCTRL_CODE = 29;

// Keep track of when a non modifier key
// is clicked to release all modifiers
const NormalClick = Variable(false);

// Keep track of modifier statuses
const Super = Variable(false);
const LAlt = Variable(false);
const LCtrl = Variable(false);
const AltGr = Variable(false);
const RCtrl = Variable(false);

const Caps = Variable(false);

brightness.connect('notify::caps-level', (_, state) => {
    Caps.set(state);
});

// Assume both shifts are the same for key.labelShift
const LShift = Variable(false);
const RShift = Variable(false);

const Shift = Variable(false);

LShift.subscribe(() => {
    Shift.set(LShift.get() || RShift.get());
});
RShift.subscribe(() => {
    Shift.set(LShift.get() || RShift.get());
});


const ModKey = (key: Key) => {
    let Mod: Variable<boolean>;

    if (key.label === 'Super') {
        Mod = Super;
    }

    // Differentiate left and right mods
    else if (key.label === 'Shift' && key.keycode === LSHIFT_CODE) {
        Mod = LShift;
    }

    else if (key.label === 'Alt' && key.keycode === LALT_CODE) {
        Mod = LAlt;
    }

    else if (key.label === 'Ctrl' && key.keycode === LCTRL_CODE) {
        Mod = LCtrl;
    }

    else if (key.label === 'Shift') {
        Mod = RShift;
    }

    else if (key.label === 'AltGr') {
        Mod = AltGr;
    }

    else if (key.label === 'Ctrl') {
        Mod = RCtrl;
    }

    const label = (
        <label
            className={`mod ${key.label}`}
            label={key.label}
        />
    ) as Widget.Label;

    const button = (
        <eventbox
            className="key"

            onButtonReleaseEvent={() => {
                console.log('mod toggled');

                execAsync(`ydotool key ${key.keycode}:${Mod.get() ? 0 : 1}`);

                label.toggleClassName('active', !Mod.get());
                Mod.set(!Mod.get());
            }}

            setup={(self) => {
                self.hook(NormalClick, () => {
                    Mod.set(false);

                    label.toggleClassName('active', false);
                    execAsync(`ydotool key ${key.keycode}:0`);
                });

                // OnHover
                self.connect('enter-notify-event', () => {
                    if (!display) {
                        return;
                    }
                    self.window.set_cursor(Gdk.Cursor.new_from_name(
                        display,
                        'pointer',
                    ));
                    self.toggleClassName('hover', true);
                });

                // OnHoverLost
                self.connect('leave-notify-event', () => {
                    self.window.set_cursor(null);
                    self.toggleClassName('hover', false);
                });
            }}
        >
            {label}
        </eventbox>
    );

    return (
        <box>
            {button}
            <Separator size={SPACING} />
        </box>
    ) as Widget.Box;
};

const RegularKey = (key: Key) => {
    const widget = (
        <eventbox
            className="key"
        >
            <label
                className={`normal ${key.label}`}
                label={key.label}

                setup={(self) => {
                    self
                        .hook(Shift, () => {
                            if (!key.labelShift) {
                                return;
                            }

                            self.label = Shift.get() ? key.labelShift : key.label;
                        })
                        .hook(Caps, () => {
                            if (key.label === 'Caps') {
                                self.toggleClassName('active', Caps.get());

                                return;
                            }

                            if (!key.labelShift) {
                                return;
                            }

                            if (key.label.match(/[A-Za-z]/)) {
                                self.label = Caps.get() ?
                                    key.labelShift :
                                    key.label;
                            }
                        })
                        .hook(AltGr, () => {
                            if (!key.labelAltGr) {
                                return;
                            }

                            self.toggleClassName('altgr', AltGr.get());
                            self.label = AltGr.get() ? key.labelAltGr : key.label;
                        });

                    // OnHover
                    self.connect('enter-notify-event', () => {
                        if (!display) {
                            return;
                        }
                        self.window.set_cursor(Gdk.Cursor.new_from_name(
                            display,
                            'pointer',
                        ));
                        self.toggleClassName('hover', true);
                    });

                    // OnHoverLost
                    self.connect('leave-notify-event', () => {
                        self.window.set_cursor(null);
                        self.toggleClassName('hover', false);
                    });
                }}
            />
        </eventbox>
    ) as Widget.EventBox;

    const gesture = Gtk.GestureLongPress.new(widget);

    gesture.delay_factor = 1.0;

    // Long press
    widget.hook(gesture, 'pressed', () => {
        const pointer = gesture.get_point(null);
        const x = pointer[1];
        const y = pointer[2];

        if ((!x || !y) || (x === 0 && y === 0)) {
            return;
        }

        console.log('Not implemented yet');

        // TODO: popup menu for accents
    });

    // OnPrimaryClickRelease
    widget.hook(gesture, 'cancelled', () => {
        const pointer = gesture.get_point(null);
        const x = pointer[1];
        const y = pointer[2];

        if ((!x || !y) || (x === 0 && y === 0)) {
            return;
        }

        console.log('key clicked');

        execAsync(`ydotool key ${key.keycode}:1`);
        execAsync(`ydotool key ${key.keycode}:0`);
        NormalClick.set(true);
    });

    return (
        <box>
            {widget}
            <Separator size={SPACING} />
        </box>
    ) as Widget.Box;
};

export default (key: Key): Widget.Box => key.keytype === 'normal' ?
    RegularKey(key) :
    ModKey(key);

import Brightness from '../../services/brightness.ts';

const { Box, EventBox, Label } = Widget;
const { execAsync } = Utils;

const { Gdk, Gtk } = imports.gi;
const display = Gdk.Display.get_default();

import Separator from '../misc/separator.ts';

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

Brightness.connect('caps', (_, state) => {
    Caps.setValue(state);
});

// Assume both shifts are the same for key.labelShift
const LShift = Variable(false);
const RShift = Variable(false);

const Shift = Variable(false);

LShift.connect('changed', () => {
    Shift.setValue(LShift.value || RShift.value);
});
RShift.connect('changed', () => {
    Shift.setValue(LShift.value || RShift.value);
});

const SPACING = 4;
const LSHIFT_CODE = 42;
const LALT_CODE = 56;
const LCTRL_CODE = 29;

// Types
import { Variable as Var } from 'types/variable.ts';
interface Key {
    keytype: string
    label: string
    labelShift?: string
    labelAltGr?: string
    shape: string
    keycode: number
}


const ModKey = (key: Key) => {
    let Mod: Var<boolean>;

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
    const label = Label({
        class_name: `mod ${key.label}`,
        label: key.label,
    });

    const button = EventBox({
        class_name: 'key',

        on_primary_click_release: () => {
            console.log('mod toggled');

            execAsync(`ydotool key ${key.keycode}:${Mod.value ? 0 : 1}`);

            label.toggleClassName('active', !Mod.value);
            Mod.setValue(!Mod.value);
        },

        setup: (self) => {
            self
                .hook(NormalClick, () => {
                    Mod.setValue(false);

                    label.toggleClassName('active', false);
                    execAsync(`ydotool key ${key.keycode}:0`);
                })

                // OnHover
                .on('enter-notify-event', () => {
                    if (!display) {
                        return;
                    }
                    self.window.set_cursor(Gdk.Cursor.new_from_name(
                        display,
                        'pointer',
                    ));
                    self.toggleClassName('hover', true);
                })

                // OnHoverLost
                .on('leave-notify-event', () => {
                    self.window.set_cursor(null);
                    self.toggleClassName('hover', false);
                });
        },
        child: label,
    });

    return Box({
        children: [
            button,
            Separator(SPACING),
        ],
    });
};

const RegularKey = (key: Key) => {
    const widget = EventBox({
        class_name: 'key',

        child: Label({
            class_name: `normal ${key.label}`,
            label: key.label,

            setup: (self) => {
                self
                    .hook(Shift, () => {
                        if (!key.labelShift) {
                            return;
                        }

                        self.label = Shift.value ? key.labelShift : key.label;
                    })
                    .hook(Caps, () => {
                        if (key.label === 'Caps') {
                            self.toggleClassName('active', Caps.value);

                            return;
                        }

                        if (!key.labelShift) {
                            return;
                        }

                        if (key.label.match(/[A-Za-z]/)) {
                            self.label = Caps.value ?
                                key.labelShift :
                                key.label;
                        }
                    })
                    .hook(AltGr, () => {
                        if (!key.labelAltGr) {
                            return;
                        }

                        self.toggleClassName('altgr', AltGr.value);
                        self.label = AltGr.value ? key.labelAltGr : key.label;
                    })

                    // OnHover
                    .on('enter-notify-event', () => {
                        if (!display) {
                            return;
                        }
                        self.window.set_cursor(Gdk.Cursor.new_from_name(
                            display,
                            'pointer',
                        ));
                        self.toggleClassName('hover', true);
                    })

                    // OnHoverLost
                    .on('leave-notify-event', () => {
                        self.window.set_cursor(null);
                        self.toggleClassName('hover', false);
                    });
            },
        }),
    });

    const gesture = Gtk.GestureLongPress.new(widget);

    gesture.delay_factor = 1.0;

    // Long press
    widget.hook(gesture, () => {
        const pointer = gesture.get_point(null);
        const x = pointer[1];
        const y = pointer[2];

        if ((!x || !y) || (x === 0 && y === 0)) {
            return;
        }

        console.log('Not implemented yet');

        // TODO: popup menu for accents
    }, 'pressed');

    // OnPrimaryClickRelease
    widget.hook(gesture, () => {
        const pointer = gesture.get_point(null);
        const x = pointer[1];
        const y = pointer[2];

        if ((!x || !y) || (x === 0 && y === 0)) {
            return;
        }

        console.log('key clicked');

        execAsync(`ydotool key ${key.keycode}:1`);
        execAsync(`ydotool key ${key.keycode}:0`);
        NormalClick.setValue(true);
    }, 'cancelled');

    return Box({
        children: [
            widget,
            Separator(SPACING),
        ],
    });
};

export default (key: Key) => key.keytype === 'normal' ?
    RegularKey(key) :
    ModKey(key);

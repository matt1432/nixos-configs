import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import Brightness from '../../services/brightness.js';

import { Box, EventBox, Label } from 'resource:///com/github/Aylur/ags/widget.js';
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

const { Gdk, Gtk } = imports.gi;
const display = Gdk.Display.get_default();

import Separator from '../misc/separator.js';

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
    Caps.value = state;
});

// Assume both shifts are the same for key.labelShift
const LShift = Variable(false);
const RShift = Variable(false);

const Shift = Variable(false);

LShift.connect('changed', () => {
    Shift.value = LShift.value || RShift.value;
});
RShift.connect('changed', () => {
    Shift.value = LShift.value || RShift.value;
});

const SPACING = 4;
const LSHIFT_CODE = 42;
const LALT_CODE = 56;
const LCTRL_CODE = 29;


/** @param {Object} key */
const ModKey = (key) => {
    let Mod;

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

    const button = EventBox({
        class_name: 'key',

        on_primary_click_release: (self) => {
            console.log('mod toggled');

            execAsync(`ydotool key ${key.keycode}:${Mod.value ? 0 : 1}`);

            // @ts-expect-error
            self.child.toggleClassName('active', !Mod.value);
            Mod.value = !Mod.value;
        },

        setup: (self) => {
            self
                .hook(NormalClick, () => {
                    Mod.value = false;

                    // @ts-expect-error
                    self.child.toggleClassName('active', false);
                    execAsync(`ydotool key ${key.keycode}:0`);
                })

                // OnHover
                .on('enter-notify-event', () => {
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
        child: Label({
            class_name: `mod ${key.label}`,
            label: key.label,
        }),
    });

    return Box({
        children: [
            button,
            Separator(SPACING),
        ],
    });
};

/** @param {Object} key */
const RegularKey = (key) => {
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
        NormalClick.value = true;
    }, 'cancelled');

    return Box({
        children: [
            widget,
            Separator(SPACING),
        ],
    });
};

/** @param {Object} key */
export default (key) => key.keytype === 'normal' ?
    RegularKey(key) :
    ModKey(key);

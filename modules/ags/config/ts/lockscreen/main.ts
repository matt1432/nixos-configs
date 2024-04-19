const { Box, Entry, Label, Window } = Widget;

import Gdk from 'gi://Gdk?version=3.0';
import Gtk from 'gi://Gtk?version=3.0';
import Lock from 'gi://GtkSessionLock?version=0.1';

import Separator from '../misc/separator.ts';

/* Types */
import { Box as AgsBox } from 'types/widgets/box';


const lock = Lock.prepare_lock();
const windows: Gtk.Window[] = [];
const blurBGs: AgsBox<Gtk.Widget, { geometry: { w: number, h: number }; }>[] = [];

const transition_duration = 1000;
const WINDOW_MARGINS = -2;
const ENTRY_SPACING = 20;
const CLOCK_SPACING = 60;
const bgCSS = ({ w = 1, h = 1 } = {}) => `
    border: 2px solid rgba(189, 147, 249, 0.8);
    background: rgba(0, 0, 0, 0.2);
    min-height: ${h}px;
    min-width: ${w}px;
    transition: min-height ${transition_duration / 2}ms,
                min-width ${transition_duration / 2}ms;
`;

const unlock = () => {
    blurBGs.forEach((b) => {
        b.css = bgCSS({
            w: b.attribute.geometry.w,
            h: 1,
        });

        Utils.timeout(transition_duration / 2, () => {
            b.css = bgCSS({
                w: 1,
                h: 1,
            });
        });
    });
    Utils.timeout(transition_duration, () => {
        lock.unlock_and_destroy();
        Gdk.Display.get_default()?.sync();
        App.quit();
    });
};

const Clock = () => Label({ class_name: 'clock' })
    .poll(1000, (self) => {
        self.label = (new Date().toLocaleString([], {
            hour: 'numeric',
            minute: 'numeric',
            hour12: true,
        }) ?? '')
            .replace('a.m.', 'AM')
            .replace('p.m.', 'PM');
    });

const PasswordPrompt = (monitor: Gdk.Monitor) => {
    const rev = Box({
        css: bgCSS(),
        attribute: {
            geometry: {} as { w: number, h: number },
        },

        setup: (self) => Utils.idle(() => {
            self.attribute.geometry = {
                w: monitor.geometry.width,
                h: monitor.geometry.height,
            };

            self.css = bgCSS({
                w: self.attribute.geometry.w,
                h: 1,
            });

            Utils.timeout(transition_duration / 2, () => {
                self.css = bgCSS({
                    w: self.attribute.geometry.w,
                    h: self.attribute.geometry.h,
                });
            });
        }),
    });

    blurBGs.push(rev);

    Window({
        name: `blur-bg-${monitor.get_model()}`,
        gdkmonitor: monitor,
        layer: 'overlay',
        anchor: ['top', 'bottom', 'right', 'left'],
        margins: [WINDOW_MARGINS],
        exclusivity: 'ignore',

        child: Box({
            hexpand: false,
            vexpand: false,
            hpack: 'center',
            vpack: 'center',
            child: rev,
        }),
    });

    const label = Label('Enter password:');

    return new Gtk.Window({
        child: Box({
            vertical: true,
            vpack: 'center',
            hpack: 'center',
            spacing: 16,

            children: [
                Clock(),

                Separator(CLOCK_SPACING, { vertical: true }),

                Box({
                    hpack: 'center',
                    class_name: 'avatar',
                }),

                Box({
                    class_name: 'entry-box',
                    vertical: true,
                    children: [
                        label,

                        Separator(ENTRY_SPACING, { vertical: true }),

                        Entry({
                            hpack: 'center',
                            xalign: 0.5,
                            visibility: false,
                            placeholder_text: 'password',

                            on_accept: (self) => {
                                self.sensitive = false;

                                Utils.authenticate(self.text ?? '')
                                    .then(() => unlock())
                                    .catch((e) => {
                                        self.text = '';
                                        label.label = e.message;
                                        self.sensitive = true;
                                    });
                            },
                        }).on('realize', (entry) => entry.grab_focus()),
                    ],
                }),
            ],
        }),
    });
};

const createWindow = (monitor: Gdk.Monitor) => {
    const win = PasswordPrompt(monitor);

    windows.push(win);
    // @ts-expect-error should be fine
    lock.new_surface(win, monitor);
    win.show();
};

const on_locked = () => {
    const display = Gdk.Display.get_default();

    for (let m = 0; m < (display?.get_n_monitors() ?? 0); m++) {
        const monitor = display?.get_monitor(m);

        if (monitor) {
            createWindow(monitor);
        }
    }
    display?.connect('monitor-added', (_, monitor) => {
        createWindow(monitor);
    });
};

const on_finished = () => {
    lock.destroy();
    Gdk.Display.get_default()?.sync();
    App.quit();
};

lock.connect('locked', on_locked);
lock.connect('finished', on_finished);


export default () => lock.lock_lock();

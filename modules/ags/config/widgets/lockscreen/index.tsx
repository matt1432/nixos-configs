import { bind, idle, timeout, Variable } from 'astal';
import { App, Astal, Gdk, Gtk, Widget } from 'astal/gtk3';
import { register } from 'astal/gobject';

import AstalAuth from 'gi://AstalAuth';
import Lock from 'gi://GtkSessionLock';

import Separator from '../misc/separator';
import { get_hyprland_monitor_desc } from '../../lib';

// This file is generated by Nix
import Vars from './vars';

/* Types */
declare global {
    function authFinger(): void;
}
@register()
class BlurredBox extends Widget.Box {
    geometry = {} as { w: number, h: number };
}


export default () => {
    const windows = new Map<Gdk.Monitor, Gtk.Window>();
    const blurBGs: BlurredBox[] = [];

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

    const lock = Lock.prepare_lock();

    const unlock = () => {
        blurBGs.forEach((b) => {
            b.set_css(bgCSS({
                w: b.geometry.w,
                h: 1,
            }));

            timeout(transition_duration / 2, () => {
                b.set_css(bgCSS({
                    w: 1,
                    h: 1,
                }));
            });
        });
        timeout(transition_duration, () => {
            lock.unlock_and_destroy();
            Gdk.Display.get_default()?.sync();
            App.quit();
        });
    };

    const Clock = () => {
        const time = Variable<string>('').poll(1000, () => {
            return (new Date().toLocaleString([], {
                hour: 'numeric',
                minute: 'numeric',
                hour12: true,
            }) ?? '')
                .replace('a.m.', 'AM')
                .replace('p.m.', 'PM');
        });

        return (
            <label
                className="lock-clock"
                label={bind(time)}
            />
        );
    };

    const PasswordPrompt = (monitor: Gdk.Monitor, visible: boolean) => {
        const rev = new BlurredBox({ css: bgCSS() });

        idle(() => {
            rev.geometry = {
                w: monitor.get_geometry().width,
                h: monitor.get_geometry().height,
            };

            rev.css = bgCSS({
                w: rev.geometry.w,
                h: 1,
            });

            timeout(transition_duration / 2, () => {
                rev.css = bgCSS({
                    w: rev.geometry.w,
                    h: rev.geometry.h,
                });
            });
        });

        blurBGs.push(rev);

        <window
            name={`blur-bg-${monitor.get_model()}`}
            namespace={`blur-bg-${monitor.get_model()}`}
            gdkmonitor={monitor}
            layer={Astal.Layer.OVERLAY}
            anchor={
                Astal.WindowAnchor.TOP |
                Astal.WindowAnchor.LEFT |
                Astal.WindowAnchor.RIGHT |
                Astal.WindowAnchor.BOTTOM
            }
            margin={WINDOW_MARGINS}
            exclusivity={Astal.Exclusivity.IGNORE}
        >
            <box
                halign={Gtk.Align.CENTER}
                valign={Gtk.Align.CENTER}
            >
                {rev}
            </box>
        </window>;

        const label = <label label="Enter password:" /> as Widget.Label;

        return new Gtk.Window({
            child: visible ?
                (
                    <box
                        vertical
                        halign={Gtk.Align.CENTER}
                        valign={Gtk.Align.CENTER}
                        spacing={16}
                    >
                        <Clock />

                        <Separator size={CLOCK_SPACING} vertical />

                        <box
                            halign={Gtk.Align.CENTER}
                            className="avatar"
                        />

                        <box
                            className="entry-box"
                            vertical
                        >
                            {label}

                            <Separator size={ENTRY_SPACING} vertical />

                            <entry
                                halign={Gtk.Align.CENTER}
                                xalign={0.5}
                                visibility={false}
                                placeholder_text="password"

                                onRealize={(self) => self.grab_focus()}

                                onActivate={(self) => {
                                    self.set_sensitive(false);

                                    AstalAuth.Pam.authenticate(self.get_text() ?? '', (_, task) => {
                                        try {
                                            AstalAuth.Pam.authenticate_finish(task);
                                            unlock();
                                        }
                                        catch (e) {
                                            self.set_text('');
                                            label.set_label((e as Error).message);
                                            self.set_sensitive(true);
                                        }
                                    });
                                }}
                            />
                        </box>
                    </box>
                ) :
                <box />,
        });
    };

    const createWindow = (monitor: Gdk.Monitor) => {
        const hyprDesc = get_hyprland_monitor_desc(monitor);
        const entryVisible = Vars.mainMonitor === hyprDesc || Vars.dupeLockscreen;
        const win = PasswordPrompt(monitor, entryVisible);

        windows.set(monitor, win);
    };

    const lock_screen = () => {
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

        lock.lock_lock();

        windows.forEach((win, monitor) => {
            lock.new_surface(win, monitor);
            win.show();
        });
    };

    const on_finished = () => {
        lock.destroy();
        Gdk.Display.get_default()?.sync();
        App.quit();
    };

    lock.connect('finished', on_finished);

    if (Vars.hasFprintd) {
        globalThis.authFinger = () => AstalAuth.Pam.authenticate('', (_, task) => {
            try {
                AstalAuth.Pam.authenticate_finish(task);
                unlock();
            }
            catch (e) {
                console.error((e as Error).message);
            }
        });
        globalThis.authFinger();
    }
    lock_screen();
};

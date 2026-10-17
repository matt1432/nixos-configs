import { readFile } from 'ags/file';
import { Astal, Gtk } from 'ags/gtk3';
import app from 'ags/gtk3/app';
import { subprocess } from 'ags/process';
import { idle } from 'ags/time';
import AstalGreet from 'gi://AstalGreet';

import { centerCursor } from '../../lib';

export default (hyprpaper: ReturnType<typeof subprocess>) => {
    const DEFAULT_NAME = 'matt';
    const PARSED_INDEX = {
        name: 0,
        uid: 2,
        gid: 3,
        desc: 4,
        home: 5,
        shell: 6,
    };

    const parsePasswd = (fileContent: string) => {
        const splitUsers = fileContent.split('\n');
        const parsedUsers = splitUsers.map((u) => {
            const user = u.split(':');

            return {
                name: user[PARSED_INDEX.name],
                uid: Number(user[PARSED_INDEX.uid]),
                gid: Number(user[PARSED_INDEX.gid]),
                desc: user[PARSED_INDEX.desc],
                home: user[PARSED_INDEX.home],
                shell: user[PARSED_INDEX.shell],
            };
        });

        // Filter out system users, nixbld users and nobody
        return parsedUsers.filter((u) => {
            return (
                u.uid >= 1000 &&
                !u.name.includes('nixbld') &&
                u.name !== 'nobody'
            );
        });
    };

    const users = parsePasswd(readFile('/etc/passwd'));

    const dropdown = new Gtk.ComboBoxText();

    dropdown.show_all();

    users.forEach((u) => {
        dropdown.append(null, u.name);
    });

    const response = (<label />) as Astal.Label;

    // Drives the PAM conversation step by step so that messages like
    // "Place your finger on the reader" from pam_fprintd get acknowledged
    // instead of aborting the login like AstalGreet.login() does
    const greeter = new AstalGreet.Greeter();

    let sessionCreated = false;

    // Password typed before the session was created, answers the first prompt
    let pendingPassword: string | null = null;

    const resetEntry = () => {
        password.set_text('');
        password.set_sensitive(true);
        password.grab_focus();
    };

    greeter.connect('secret-request', (_, message: string) => {
        if (pendingPassword !== null) {
            greeter.post_auth(pendingPassword);
            pendingPassword = null;
        }
        else {
            response.set_label(message.trim());
            resetEntry();
        }
    });

    greeter.connect('visible-request', (_, message: string) => {
        pendingPassword = null;
        response.set_label(message.trim());
        resetEntry();
    });

    greeter.connect('info-message', (_, message: string) => {
        response.set_label(message.trim());
    });

    greeter.connect('error-message', (_, message: string) => {
        response.set_label(message.trim());
    });

    greeter.connect('cancelled', (_, error: AstalGreet.Error) => {
        sessionCreated = false;
        pendingPassword = null;
        response.set_label(error.description);
        resetEntry();
    });

    greeter.connect('authenticated', () => {
        response.set_label('');

        greeter.start_session(['Hyprland'], [], () => {
            app.get_window('greeter')?.set_visible(false);
            hyprpaper.kill();

            setTimeout(() => {
                app.quit();
            }, 500);
        });
    });

    const password = (
        <entry
            placeholderText="Password"
            visibility={false}
            secondaryIconName="view-reveal-symbolic"
            secondaryIconTooltipText="Show password"
            onIconPress={(self, position) => {
                if (position !== Gtk.EntryIconPosition.SECONDARY) {
                    return;
                }

                const visible = !self.get_visibility();

                self.set_visibility(visible);
                self.set_icon_from_icon_name(
                    Gtk.EntryIconPosition.SECONDARY,
                    visible ? 'view-conceal-symbolic' : 'view-reveal-symbolic',
                );
                self.set_icon_tooltip_text(
                    Gtk.EntryIconPosition.SECONDARY,
                    visible ? 'Hide password' : 'Show password',
                );
            }}
            $={(self) =>
                idle(() => {
                    self.grab_focus();
                })
            }
            onActivate={(self) => {
                // Prevent sending a second request while one is in flight
                if (!self.get_sensitive()) {
                    return;
                }

                self.set_sensitive(false);
                response.set_label('');

                if (sessionCreated) {
                    // Answering a follow-up prompt from PAM
                    greeter.post_auth(self.get_text());
                }
                else {
                    // An empty password makes greetd's PAM stack fall back
                    // to pam_fprintd which waits for the fingerprint
                    sessionCreated = true;
                    pendingPassword = self.get_text();
                    greeter.create_session(dropdown.get_active_text() ?? '');
                }
            }}
        />
    ) as Gtk.Entry;

    return (
        <window
            name="greeter"
            application={app}
            keymode={Astal.Keymode.ON_DEMAND}
            visible={false}
            $={(self) => {
                centerCursor();
                setTimeout(() => {
                    self.set_visible(true);
                    password.grab_focus();
                }, 1000);
            }}
        >
            <box
                vertical
                halign={Gtk.Align.CENTER}
                valign={Gtk.Align.CENTER}
                hexpand
                vexpand
                class="base"
            >
                <box
                    vertical
                    halign={Gtk.Align.CENTER}
                    valign={Gtk.Align.CENTER}
                    hexpand
                    vexpand
                    class="linked"
                    $={() => {
                        idle(() => {
                            const usernames = users.map((u) => u.name);

                            if (usernames.includes(DEFAULT_NAME)) {
                                dropdown.set_active(
                                    usernames.indexOf(DEFAULT_NAME),
                                );
                            }
                        });
                    }}
                >
                    {dropdown}
                    {password}
                </box>

                {response}
            </box>
        </window>
    );
};

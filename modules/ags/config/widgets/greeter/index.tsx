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

    const password = (
        <entry
            placeholderText="Password"
            visibility={false}
            $={(self) =>
                idle(() => {
                    self.grab_focus();
                })
            }
            onActivate={(self) => {
                AstalGreet.login(
                    dropdown.get_active_text() ?? '',
                    self.get_text() || '',
                    'Hyprland',
                    (_, res) => {
                        try {
                            AstalGreet.login_finish(res);
                            app.get_window('greeter')?.set_visible(false);
                            hyprpaper.kill();

                            setTimeout(() => {
                                app.quit();
                            }, 500);
                        }
                        catch (error) {
                            response.set_label(JSON.stringify(error));
                        }
                    },
                );
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

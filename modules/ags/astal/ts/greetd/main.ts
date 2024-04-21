const { Box, Entry, Label, Window } = Widget;
const { idle, readFileAsync } = Utils;

const greetd = await Service.import('greetd');

const { Gtk } = imports.gi;

const DEFAULT_NAME = 'matt';

// Types
import { StringObject } from 'types/@girs/gtk-4.0/gtk-4.0.cjs';


const parsePasswd = (fileContent: string) => {
    const splitUsers = fileContent.split('\n');
    const parsedUsers = splitUsers.map((u) => {
        const user = u.split(':');

        return {
            name: user[0],
            uid: Number(user[2]),
            gid: Number(user[3]),
            desc: user[4],
            home: user[5],
            shell: user[6],
        };
    });

    // Filter out system users, nixbld users and nobody
    return parsedUsers.filter((u) => {
        return u.uid >= 1000 &&
            !u.name.includes('nixbld') &&
            u.name !== 'nobody';
    });
};
const users = parsePasswd(await readFileAsync('/etc/passwd'));

const dropdown = Gtk.DropDown.new_from_strings(users.map((u) => u.name));

const password = Entry({
    placeholderText: 'Password',
    visibility: false,

    setup: (self) => idle(() => {
        self.grab_focus();
    }),

    on_accept: () => {
        greetd.login(
            (dropdown.selectedItem as StringObject)['string'] || '',
            password.text || '',
            'Hyprland',

        ).catch((error) => {
            response.label = JSON.stringify(error);
        });
    },

});

const response = Label();

export default () => Window({
    name: 'greeter',
    keymode: 'on-demand',

    child: Box({
        vertical: true,
        hpack: 'center',
        vpack: 'center',
        hexpand: true,
        vexpand: true,
        cssClasses: ['base'],

        children: [
            Box({
                vertical: true,
                hpack: 'center',
                vpack: 'center',
                hexpand: true,
                vexpand: true,

                setup: (self) => {
                    self.add_css_class('linked');

                    idle(() => {
                        const usernames = [] as string[];

                        for (let i = 0; i < dropdown.model.get_n_items(); ++i) {
                            const name = (dropdown.model.get_item(i) as StringObject)['string'];

                            if (name) {
                                usernames.push(name);
                            }
                        }

                        if (usernames.includes(DEFAULT_NAME)) {
                            dropdown.set_selected(usernames.indexOf(DEFAULT_NAME));
                        }
                    });
                },

                children: [
                    dropdown,
                    password,
                ],
            }),
            response,
        ],
    }),
});

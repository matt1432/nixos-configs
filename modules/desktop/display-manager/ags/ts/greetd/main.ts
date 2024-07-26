const { Box, Entry, Label, Window } = Widget;
const { idle, readFileAsync } = Utils;

const greetd = await Service.import('greetd');

const { Gtk } = imports.gi;

const DEFAULT_NAME = 'matt';


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

const dropdown = new Gtk.ComboBoxText();

users.forEach((u) => {
    dropdown.append(null, u.name);
});

const password = Entry({
    placeholderText: 'Password',
    visibility: false,

    setup: (self) => idle(() => {
        self.grab_focus();
    }),

    on_accept: () => {
        greetd.login(
            dropdown.get_active_text() ?? '',
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
        class_names: ['base'],

        children: [
            Box({
                vertical: true,
                hpack: 'center',
                vpack: 'center',
                hexpand: true,
                vexpand: true,
                class_names: ['linked'],

                setup: () => {
                    idle(() => {
                        const usernames = users.map((u) => u.name);

                        if (usernames.includes(DEFAULT_NAME)) {
                            dropdown.set_active(usernames.indexOf(DEFAULT_NAME));
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

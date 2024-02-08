/* eslint no-magic-numbers: 0 */

const { Box, Button, Entry, Label, Menu, MenuItem, Window } = Widget;
const { execAsync, idle, readFileAsync } = Utils;

const greetd = await Service.import('greetd');

const { Gdk } = imports.gi;

const DEFAULT_NAME = 'matt';

// Types
type User = {
    name: string;
    uid: number;
    gid: number;
    desc: string;
    home: string;
    shell: string;
};


// Run Wallpaper daemon here to not cause issues at startup
execAsync(['swww', 'init', '--no-cache']).then(() => {
    execAsync([
        'swww', 'img', '-t', 'none',
        `${App.configDir}/.wallpaper`,
    ]).catch(print);
}).catch(print);

// Put ref of Label here to change it easily later
const name = Label(DEFAULT_NAME);

// Initiate menu here to not have garbage collection take it away
// TODO: figure out type
let menu;

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

// FIXME: make menu scrollable
const DropdownMenu = (users: User[]) => Menu({
    attach_widget: dropdown,
    children: users.map((u) => MenuItem({
        on_activate: () => {
            name.label = u.name;
        },

        child: Label({
            label: u.name,
            justification: 'center',
            css: `min-width: ${dropdown.get_allocated_width() / 2}px;`,
        }),
    })),
});

const dropdown = Button({
    child: name,

    setup: () => {
        idle(() => {
            readFileAsync('/etc/passwd').then((out) => {
                const users = parsePasswd(out);

                menu = DropdownMenu(users);
            }).catch(print);
        });
    },

    on_primary_click_release: (self, event) => {
        menu.popup_at_widget(
            self,
            Gdk.Gravity.SOUTH,
            Gdk.Gravity.NORTH,
            event,
        );
    },
});

const password = Entry({
    placeholder_text: 'Password',
    visibility: false,

    on_accept: () => {
        greetd.login(
            name.label || '',
            password.text || '',
            'Hyprland',

        ).catch((error) => {
            response.label = JSON.stringify(error);
        });
    },

}).on('realize', (entry) => entry.grab_focus());

const response = Label();

const win = Window({
    name: 'greeter',
    css: 'background-color: transparent;',
    anchor: ['top', 'left', 'right', 'bottom'],
    keymode: 'on-demand',

    child: Box({
        vertical: true,
        hpack: 'center',
        vpack: 'center',
        hexpand: true,
        vexpand: true,

        children: [
            dropdown,
            password,
            response,
        ],
    }),
});

export default { windows: [win] };

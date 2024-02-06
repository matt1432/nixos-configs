const { Box, Button, Entry, Label, Menu, MenuItem, Window } = Widget;
const { execAsync, idle, readFileAsync } = Utils;

const greetd = await Service.import('greetd');

const { Gdk } = imports.gi;

const DEFAULT_NAME = 'matt';


execAsync(['swww', 'init', '--no-cache']).then(() => {
    execAsync([
        'swww', 'img', '-t', 'none',
        `${App.configDir}/.wallpaper`,
    ]).catch(print);
}).catch(print);

const name = Label(DEFAULT_NAME);
let menu;

const dropdown = Button({
    child: name,
    setup: () => {
        idle(() => {
            readFileAsync('/etc/passwd').then((out) => {
                const users = out.split('\n')
                    .map((u) => {
                        const user = u.split(':');
                        let i = 2;

                        return {
                            name: user[0],
                            uid: Number(user[i++]),
                            gid: Number(user[i++]),
                            desc: user[i++],
                            home: user[i++],
                            shell: user[i],
                        };
                    })
                    .filter((u) => {
                        return u.uid >= 1000 &&
                            !u.name.includes('nixbld') &&
                            u.name !== 'nobody';
                    });

                // FIXME: make menu scrollable
                menu = Menu({
                    attach_widget: dropdown,
                    children: users.map((u) => MenuItem({
                        on_activate: () => {
                            name.label = u.name;
                        },

                        child: Label({
                            label: u.name,
                            justification: 'center',
                            css: `
                             min-width: ${dropdown.get_allocated_width() / 2}px;
                            `,
                        }),
                    })),
                });
            }).catch(print);
        });
    },

    on_primary_click_release: (_, event) => {
        menu.popup_at_widget(
            dropdown,
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

        ).catch((err) => {
            response.label = JSON.stringify(err);
        });
    },
});

const response = Label();

const win = Window({
    name: 'greeter',
    css: 'background-color: transparent;',
    anchor: ['top', 'left', 'right', 'bottom'],
    keymode: 'exclusive',

    setup: () => {
        idle(() => {
            password.grab_focus();
        });
    },

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

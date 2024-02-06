const { idle } = Utils;
const greetd = await Service.import('greetd');

const name = Widget.Entry({
    placeholder_text: 'Username',
    on_accept: () => password.grab_focus(),
});

const password = Widget.Entry({
    placeholder_text: 'Password',
    visibility: false,
    on_accept: () => {
        greetd.login(
            name.text || '',
            password.text || '',
            'Hyprland',

        ).catch((err) => {
            response.label = JSON.stringify(err);
        });
    },
});

const response = Widget.Label();

const win = Widget.Window({
    name: 'greeter',
    css: 'background-color: transparent;',
    anchor: ['top', 'left', 'right', 'bottom'],
    keymode: 'exclusive',

    setup: () => {
        idle(() => {
            password.grab_focus();
        });
    },

    child: Widget.Box({
        vertical: true,
        hpack: 'center',
        vpack: 'center',
        hexpand: true,
        vexpand: true,
        children: [
            name,
            password,
            response,
        ],
    }),
});

export default { windows: [win] };

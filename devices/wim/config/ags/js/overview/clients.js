import App from 'resource:///com/github/Aylur/ags/app.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

import { Icon, Revealer } from 'resource:///com/github/Aylur/ags/widget.js';
import { timeout } from 'resource:///com/github/Aylur/ags/utils.js';

import { WindowButton } from './dragndrop.js';
import * as VARS from './variables.js';

const scale = (size) => (size * VARS.SCALE) - VARS.MARGIN;
const getFontSize = (client) => {
    const valX = scale(client.size[0]) * VARS.ICON_SCALE;
    const valY = scale(client.size[1]) * VARS.ICON_SCALE;

    const size = Math.min(valX, valY);

    return size <= 0 ? 0.1 : size;
};

const IconStyle = (client) => `
    min-width:  ${scale(client.size[0])}px;
    min-height: ${scale(client.size[1])}px;
    font-size:  ${getFontSize(client)}px;
`;


const Client = (client, active, clients, box) => {
    const wsName = String(client.workspace.name).replace('special:', '');
    const wsId = client.workspace.id;
    const addr = `address:${client.address}`;

    return Revealer({
        transition: 'crossfade',

        setup: (rev) => {
            rev.revealChild = true;
        },

        properties: [
            ['address', client.address],
            ['toDestroy', false],
        ],

        child: WindowButton({
            mainBox: box,
            address: client.address,

            onSecondaryClickRelease: () => {
                Hyprland.sendMessage(`dispatch closewindow ${addr}`);
            },

            onPrimaryClickRelease: () => {
                if (wsId < 0) {
                    if (client.workspace.name === 'special') {
                        Hyprland.sendMessage('dispatch ' +
                            `movetoworkspacesilent special:${wsId},${addr}`)
                            .then(
                                Hyprland.sendMessage('dispatch ' +
                                    `togglespecialworkspace ${wsId}`)
                                    .then(
                                        () => App.closeWindow('overview'),
                                    ).catch(print),
                            ).catch(print);
                    }
                    else {
                        Hyprland.sendMessage('dispatch ' +
                            `togglespecialworkspace ${wsName}`).then(
                            () => App.closeWindow('overview'),
                        ).catch(print);
                    }
                }
                else {
                    // Close special workspace if one is opened
                    const activeAddress = Hyprland.active.client.address;

                    const currentActive = clients.find((c) => {
                        return c.address === activeAddress;
                    });

                    if (currentActive && currentActive.workspace.id < 0) {
                        const currentSpecial = `${currentActive.workspace.name}`
                            .replace('special:', '');

                        Hyprland.sendMessage('dispatch ' +
                            `togglespecialworkspace ${currentSpecial}`)
                            .catch(print);
                    }

                    Hyprland.sendMessage(`dispatch focuswindow ${addr}`).then(
                        () => App.closeWindow('overview'),
                    ).catch(print);
                }
            },

            child: Icon({
                className: `window ${active}`,
                css: `${IconStyle(client)} font-size: 10px;`,
                icon: client.class,
            }),
        }),
    });
};

export const updateClients = (box) => {
    Hyprland.sendMessage('j/clients').then((out) => {
        const clients = JSON.parse(out).filter((client) => client.class);

        box._workspaces.forEach((workspace) => {
            const fixed = workspace.getFixed();
            const toRemove = fixed.get_children();

            clients.filter((client) => client.workspace.id === workspace._id)
                .forEach((client) => {
                    let active = '';

                    if (client.address === Hyprland.active.client.address) {
                        active = 'active';
                    }

                    // TODO: fix multi monitor issue. this is just a temp fix
                    client.at[1] -= 2920;

                    // Special workspaces that haven't been opened yet
                    // return a size of 0. We need to set them to default
                    // values to show the workspace properly
                    if (client.size[0] === 0) {
                        client.size[0] = VARS.DEFAULT_SPECIAL.SIZE_X;
                        client.size[1] = VARS.DEFAULT_SPECIAL.SIZE_Y;
                        client.at[0] = VARS.DEFAULT_SPECIAL.POS_X;
                        client.at[1] = VARS.DEFAULT_SPECIAL.POS_Y;
                    }

                    const newClient = [
                        fixed.get_children()
                            .find((ch) => ch._address === client.address),
                        client.at[0] * VARS.SCALE,
                        client.at[1] * VARS.SCALE,
                    ];

                    // If it exists already
                    if (newClient[0]) {
                        toRemove.splice(toRemove.indexOf(newClient[0]), 1);
                        fixed.move(...newClient);
                    }
                    else {
                        newClient[0] = Client(client, active, clients, box);
                        fixed.put(...newClient);
                    }

                    // Set a timeout here to have an animation when the icon first appears
                    timeout(1, () => {
                        newClient[0].child.child.className = `window ${active}`;
                        newClient[0].child.child.setCss(IconStyle(client));
                    });
                });

            fixed.show_all();
            toRemove.forEach((ch) => {
                if (ch._toDestroy) {
                    ch.destroy();
                }
                else {
                    ch.revealChild = false;
                    ch._toDestroy = true;
                }
            });
        });
    }).catch(print);
};

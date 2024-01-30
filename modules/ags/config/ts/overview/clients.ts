const Hyprland = await Service.import('hyprland');

const { Icon, Revealer } = Widget;
const { timeout } = Utils;

import { WindowButton } from './dragndrop.ts';
import * as VARS from './variables.ts';

// Types
import { Client as HyprClient } from 'types/service/hyprland.ts';
import AgsRevealer from 'types/widgets/revealer.ts';
import AgsBox from 'types/widgets/box.ts';
import AgsButton from 'types/widgets/button.ts';
import AgsIcon from 'types/widgets/icon.ts';

const scale = (size: number) => (size * VARS.SCALE) - VARS.MARGIN;

const getFontSize = (client: HyprClient) => {
    const valX = scale(client.size[0]) * VARS.ICON_SCALE;
    const valY = scale(client.size[1]) * VARS.ICON_SCALE;

    const size = Math.min(valX, valY);

    return size <= 0 ? 0.1 : size;
};

const IconStyle = (client: HyprClient) => `
    min-width:  ${scale(client.size[0])}px;
    min-height: ${scale(client.size[1])}px;
    font-size:  ${getFontSize(client)}px;
`;


const Client = (
    client: HyprClient,
    active: boolean,
    clients: Array<HyprClient>,
    box: AgsBox,
) => {
    const wsName = String(client.workspace.name).replace('special:', '');
    const wsId = client.workspace.id;
    const addr = `address:${client.address}`;

    return Revealer({
        transition: 'crossfade',
        reveal_child: true,

        attribute: {
            address: client.address,
            to_destroy: false,
        },

        child: WindowButton({
            mainBox: box,
            address: client.address,

            on_secondary_click_release: () => {
                Hyprland.sendMessage(`dispatch closewindow ${addr}`);
            },

            on_primary_click_release: () => {
                if (wsId < 0) {
                    if (client.workspace.name === 'special') {
                        Hyprland.sendMessage('dispatch ' +
                            `movetoworkspacesilent special:${wsId},${addr}`)
                            .then(() => {
                                Hyprland.sendMessage('dispatch ' +
                                    `togglespecialworkspace ${wsId}`)
                                    .then(() => {
                                        App.closeWindow('overview');
                                    }).catch(print);
                            }).catch(print);
                    }
                    else {
                        Hyprland.sendMessage('dispatch ' +
                            `togglespecialworkspace ${wsName}`)
                            .then(() => {
                                App.closeWindow('overview');
                            }).catch(print);
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

                    Hyprland.sendMessage(`dispatch focuswindow ${addr}`)
                        .then(() => {
                            App.closeWindow('overview');
                        }).catch(print);
                }
            },

            child: Icon({
                class_name: `window ${active ? 'active' : ''}`,
                css: `${IconStyle(client)} font-size: 10px;`,
                icon: client.class,
            }),
        }),
    });
};

export const updateClients = (box: AgsBox) => {
    Hyprland.sendMessage('j/clients').then((out) => {
        let clients = JSON.parse(out) as Array<HyprClient>;

        clients = clients.filter((client) => client.class);

        box.attribute.workspaces.forEach(
            (workspace: AgsRevealer) => {
                const fixed = workspace.attribute.get_fixed();
                const toRemove = fixed.get_children() as Array<AgsRevealer>;

                clients.filter((client) =>
                    client.workspace.id === workspace.attribute.id)
                    .forEach((client) => {
                        const active =
                        client.address === Hyprland.active.client.address;

                        // TODO: see if this works on multi monitor setup
                        const alloc = box.get_allocation();
                        let monitor = box.get_display()
                            .get_monitor_at_point(alloc.x, alloc.y);

                        monitor = Hyprland.monitors.find((mon) => {
                            return mon.make === monitor.manufacturer &&
                                mon.model === monitor.model;
                        });

                        client.at[0] -= monitor.x;
                        client.at[1] -= monitor.y;

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
                            (fixed.get_children() as Array<AgsRevealer>)
                                .find((ch) =>
                                    ch.attribute.address === client.address),
                            client.at[0] * VARS.SCALE,
                            client.at[1] * VARS.SCALE,
                        ] as [AgsRevealer, number, number];

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
                            ((newClient[0].child as AgsButton)
                                .child as AgsIcon)
                                .class_name = `window ${active}`;

                            ((newClient[0].child as AgsButton)
                                .child as AgsIcon).setCss(IconStyle(client));
                        });
                    });

                fixed.show_all();
                toRemove.forEach((ch) => {
                    if (ch.attribute.to_destroy) {
                        ch.destroy();
                    }
                    else {
                        ch.reveal_child = false;
                        ch.attribute.to_destroy = true;
                    }
                });
            },
        );
    }).catch(print);
};

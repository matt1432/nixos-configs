const Applications = await Service.import('applications');
const Hyprland = await Service.import('hyprland');

const { Box, Icon, Label, Scrollable, Stack } = Widget;
const { execAsync, timeout } = Utils;

import PopupWindow from '../misc/popup.ts';
import CursorBox from '../misc/cursorbox.ts';
import { Client } from 'types/service/hyprland';


const takeScreenshot = (selector: string, delay = 1000): void => {
    App.closeWindow('win-screenshot');
    timeout(delay, () => {
        execAsync(['bash', '-c', `grim ${selector} - | satty -f -`])
            .catch(console.error);
    });
};

export default () => {
    const windowList = Box({
        vertical: true,
    });

    const updateWindows = async() => {
        if (!App.getWindow('win-screenshot')?.visible) {
            return;
        }

        windowList.children = (JSON.parse(
            await Hyprland.messageAsync('j/clients'),
        ) as Client[])
            .filter((client) => client.workspace.id === Hyprland.active.workspace.id)
            .map((client) => CursorBox({
                class_name: 'item-btn',

                on_primary_click_release: () => {
                    takeScreenshot(`-w ${client.address}`);
                },

                child: Box({
                    hpack: 'center',

                    children: [
                        Icon(Applications
                            .query(client.class)[0]?.app.get_string('Icon') ?? ''),

                        Label({
                            label: client.title,
                            truncate: 'end',
                            max_width_chars: 50,
                        }),
                    ],
                }),
            }));
    };


    const stack = Stack({
        transition: 'slide_left_right',

        children: {
            monitors: Scrollable({
                child: Box({
                    vertical: true,
                }).hook(Hyprland, (self) => {
                    self.children = Hyprland.monitors.map((monitor) => CursorBox({
                        class_name: 'item-btn',

                        on_primary_click_release: () => {
                            takeScreenshot(`-o ${monitor.name}`);
                        },

                        child: Label({
                            label: `${monitor.name}: ${monitor.description}`,
                            truncate: 'end',
                            max_width_chars: 50,
                        }),
                    }));
                }, 'notify::monitors'),
            }),

            windows: Scrollable({
                child: windowList
                    .hook(Hyprland, updateWindows, 'notify::clients')
                    .hook(Hyprland.active.workspace, updateWindows),
            }),
        },
    });

    // TODO: highlight monitor when hovered
    const monitorsButton = CursorBox({
        class_name: 'header-btn',

        on_primary_click_release: () => {
            stack.shown = 'monitors';
        },

        child: Box({
            hpack: 'center',

            children: [
                Icon('display-symbolic'),
                Label('monitors'),
            ],
        }),
    });

    const windowsButton = CursorBox({
        class_name: 'header-btn',

        on_primary_click_release: () => {
            stack.shown = 'windows';
        },

        child: Box({
            hpack: 'center',

            children: [
                Icon('window-symbolic'),
                Label('windows'),
            ],
        }),
    });

    const regionButton = CursorBox({
        class_name: 'header-btn',

        on_primary_click_release: () => {
            takeScreenshot('-g "$(slurp)"', 0);
        },

        child: Box({
            hpack: 'center',

            children: [
                Icon('tool-pencil-symbolic'),
                Label('region'),
            ],
        }),
    });

    return PopupWindow({
        name: 'screenshot',
        on_open: () => {
            updateWindows();
        },
        child: Box({
            class_name: 'screenshot',
            vertical: true,

            children: [
                Box({
                    class_name: 'header',
                    homogeneous: true,

                    children: [
                        monitorsButton,
                        windowsButton,
                        regionButton,
                    ],
                }).hook(stack, () => {
                    switch (stack.shown) {
                        case 'monitors':
                            monitorsButton.toggleClassName('active', true);
                            windowsButton.toggleClassName('active', false);
                            break;

                        case 'windows':
                            monitorsButton.toggleClassName('active', false);
                            windowsButton.toggleClassName('active', true);
                            break;

                        default:
                            break;
                    }
                }, 'notify::shown'),

                stack,
            ],
        }),
    });
};

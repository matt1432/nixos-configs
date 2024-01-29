import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';

import { Box, EventBox, Revealer, Window } from 'resource:///com/github/Aylur/ags/widget.js';

// Types
import { Variable as Var } from 'types/variable';
import { BoxGeneric, DefaultProps } from 'global-types';


const BarCloser = (variable: Var<boolean>) => Window({
    name: 'bar-closer',
    visible: false,
    anchor: ['top', 'bottom', 'left', 'right'],
    layer: 'overlay',

    child: EventBox({
        on_hover: (self) => {
            variable.value = false;
            const parent = self.get_parent();

            if (parent) {
                parent.visible = false;
            }
        },

        child: Box({
            css: 'padding: 1px',
        }),
    }),
});

export default (props?: DefaultProps) => {
    const Revealed = Variable(true);
    const barCloser = BarCloser(Revealed);

    return Box({
        css: 'min-height: 1px',
        hexpand: true,
        vertical: true,

        setup: (self) => {
            const checkCurrentWsFsState = () => {
                const workspace = Hyprland.getWorkspace(
                    Hyprland.active.workspace.id,
                );

                if (workspace) {
                    Revealed.value = !workspace['hasfullscreen'];
                }
            };

            const checkGlobalFsState = (_: BoxGeneric, fullscreen: boolean) => {
                Revealed.value = !fullscreen;
            };

            self
                .hook(Hyprland.active, checkCurrentWsFsState)
                .hook(Hyprland, checkGlobalFsState, 'fullscreen');
        },

        children: [
            Revealer({
                ...props,
                transition: 'slide_down',
                reveal_child: true,

            }).bind('reveal_child', Revealed),

            Revealer({
                reveal_child: Revealed.bind()
                    .transform((v) => !v),

                child: EventBox({
                    on_hover: () => {
                        barCloser.visible = true;
                        Revealed.value = true;
                    },

                    child: Box({
                        css: 'min-height: 5px;',
                    }),
                }),
            }),
        ],
    });
};

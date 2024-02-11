const Hyprland = await Service.import('hyprland');

const { Box, EventBox, Revealer, Window } = Widget;

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
            variable.setValue(false);
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
                    Revealed.setValue(!workspace['hasfullscreen']);
                }
            };

            const checkGlobalFsState = (_: BoxGeneric, fullscreen: boolean) => {
                Revealed.setValue(!fullscreen);
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
                        Revealed.setValue(true);
                    },

                    child: Box({
                        css: 'min-height: 5px;',
                    }),
                }),
            }),
        ],
    });
};

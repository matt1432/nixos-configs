import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';

import { Box, EventBox, Revealer, Window } from 'resource:///com/github/Aylur/ags/widget.js';


/** @param {import('types/variable.js').Variable} variable */
const BarCloser = (variable) => Window({
    name: 'bar-closer',
    visible: false,
    anchor: ['top', 'bottom', 'left', 'right'],
    layer: 'overlay',

    child: EventBox({
        on_hover: (self) => {
            variable.value = false;
            // @ts-expect-error
            self.get_parent().visible = false;
        },

        child: Box({
            css: 'padding: 1px',
        }),
    }),
});

/** @param {import('types/widgets/revealer').RevealerProps} props */
export default (props) => {
    const Revealed = Variable(true);
    const barCloser = BarCloser(Revealed);

    return Box({
        css: 'min-height: 1px',
        hexpand: true,
        vertical: true,

        setup: (self) => {
            self
                .hook(Hyprland.active, () => {
                    const workspace = Hyprland.getWorkspace(
                        Hyprland.active.workspace.id,
                    );

                    if (workspace) {
                        Revealed.value = !workspace['hasfullscreen'];
                    }
                })

                .hook(Hyprland, (_, fullscreen) => {
                    Revealed.value = !fullscreen;
                }, 'fullscreen');
        },

        children: [
            Revealer({
                ...props,
                transition: 'slide_down',
                reveal_child: true,

                binds: [['revealChild', Revealed, 'value']],
            }),

            Revealer({
                binds: [['revealChild', Revealed, 'value', (v) => !v]],

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

import { createState } from 'ags';
import { Astal, Gtk } from 'ags/gtk3';
import AstalHyprland from 'gi://AstalHyprland';

import { hyprMessage } from '../../../lib';

interface Keyboard {
    address: string;
    name: string;
    rules: string;
    model: string;
    layout: string;
    variant: string;
    options: string;
    active_keymap: string;
    main: boolean;
}

const DEFAULT_KB = 'at-translated-set-2-keyboard';

export default () => {
    const [isHovered, setIsHovered] = createState(false);

    const hyprland = AstalHyprland.get_default();

    const getKbdLayout = (self: Astal.Label, _: string, layout?: string) => {
        if (layout) {
            if (layout === 'error') {
                return;
            }

            const shortName = layout.match(/\(([A-Za-z]+)\)/);

            self.label = shortName ? shortName[1] : layout;
        }
        else {
            // At launch, kb layout is undefined
            hyprMessage('j/devices')
                .then((obj) => {
                    const keyboards = Array.from(
                        JSON.parse(obj).keyboards,
                    ) as Keyboard[];
                    const kb = keyboards.find((v) => v.name === DEFAULT_KB);

                    if (kb) {
                        layout = kb.active_keymap;

                        const shortName = layout.match(/\(([A-Za-z]+)\)/);

                        self.label = shortName ? shortName[1] : layout;
                    }
                    else {
                        self.label = 'None';
                    }
                })
                .catch(print);
        }
    };

    return (
        <cursor-button
            class="bar-item keyboard"
            cursor="pointer"
            onHover={() => setIsHovered(true)}
            onHoverLost={() => setIsHovered(false)}
        >
            <box>
                <icon icon="input-keyboard-symbolic" />

                <revealer
                    revealChild={isHovered}
                    transitionType={Gtk.RevealerTransitionType.SLIDE_LEFT}
                >
                    <label
                        $={(self) => {
                            hyprland.connect('keyboard-layout', getKbdLayout);
                            getKbdLayout(self, '');
                        }}
                    />
                </revealer>
            </box>
        </cursor-button>
    );
};

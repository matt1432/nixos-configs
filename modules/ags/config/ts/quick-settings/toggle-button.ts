const Mpris = await Service.import('mpris');

const { CenterBox, Icon, ToggleButton } = Widget;

const { Gdk } = imports.gi;
const display = Gdk.Display.get_default();

// Types
import { RevealerGeneric } from 'global-types';


export default (rev: RevealerGeneric) => {
    const child = Icon({
        icon: 'down-large-symbolic',
        class_name: 'arrow',
        css: '-gtk-icon-transform: rotate(180deg);',
    });

    const button = CenterBox({
        center_widget: ToggleButton({
            setup: (self) => {
                // Open at startup if there are players
                const id = Mpris.connect('changed', () => {
                    self.set_active(Mpris.players.length > 0);
                    Mpris.disconnect(id);
                });

                self
                    .on('toggled', () => {
                        if (self.get_active()) {
                            child
                                .setCss('-gtk-icon-transform: rotate(0deg);');
                            rev.reveal_child = true;
                        }
                        else {
                            child
                                .setCss('-gtk-icon-transform: rotate(180deg);');
                            rev.reveal_child = false;
                        }
                    })

                    // OnHover
                    .on('enter-notify-event', () => {
                        if (!display) {
                            return;
                        }
                        self.window.set_cursor(Gdk.Cursor.new_from_name(
                            display,
                            'pointer',
                        ));
                        self.toggleClassName('hover', true);
                    })

                    // OnHoverLost
                    .on('leave-notify-event', () => {
                        self.window.set_cursor(null);
                        self.toggleClassName('hover', false);
                    });
            },

            child,
        }),
    });

    return button;
};

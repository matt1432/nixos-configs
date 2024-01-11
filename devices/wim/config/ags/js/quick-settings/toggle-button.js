import App from 'resource:///com/github/Aylur/ags/app.js';
import Mpris from 'resource:///com/github/Aylur/ags/service/mpris.js';

import { CenterBox, Icon, ToggleButton } from 'resource:///com/github/Aylur/ags/widget.js';

const { Gdk } = imports.gi;
const display = Gdk.Display.get_default();


/** @param {import('types/widgets/revealer').default} rev */
export default (rev) => CenterBox({
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
                        self.child
                        // @ts-expect-error
                            ?.setCss('-gtk-icon-transform: rotate(0deg);');
                        rev.reveal_child = true;
                    }
                    else {
                        self.child
                        // @ts-expect-error
                            ?.setCss('-gtk-icon-transform: rotate(180deg);');
                        rev.reveal_child = false;
                    }
                })

                // OnHover
                .on('enter-notify-event', () => {
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

        child: Icon({
            icon: `${App.configDir}/icons/down-large.svg`,
            class_name: 'arrow',
            css: '-gtk-icon-transform: rotate(180deg);',
        }),
    }),
});

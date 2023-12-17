import App from 'resource:///com/github/Aylur/ags/app.js';
import Mpris from 'resource:///com/github/Aylur/ags/service/mpris.js';

import { CenterBox, Icon, ToggleButton } from 'resource:///com/github/Aylur/ags/widget.js';


export default (rev) => CenterBox({
    center_widget: ToggleButton({
        cursor: 'pointer',

        setup: (self) => {
            // Open at startup if there are players
            const id = Mpris.connect('changed', () => {
                self.set_active(Mpris.players.length > 0);
                Mpris.disconnect(id);
            });

            self.on('toggled', () => {
                if (self.get_active()) {
                    self.get_children()[0]
                        .setCss('-gtk-icon-transform: rotate(0deg);');
                    rev.revealChild = true;
                }
                else {
                    self.get_children()[0]
                        .setCss('-gtk-icon-transform: rotate(180deg);');
                    rev.revealChild = false;
                }
            });
        },

        child: Icon({
            icon: `${App.configDir }/icons/down-large.svg`,
            className: 'arrow',
            css: '-gtk-icon-transform: rotate(180deg);',
        }),
    }),
    start_widget: null,
    end_widget: null,
});

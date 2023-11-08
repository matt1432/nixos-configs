import App   from 'resource:///com/github/Aylur/ags/app.js';
import Mpris from 'resource:///com/github/Aylur/ags/service/mpris.js';
import { Icon, ToggleButton } from 'resource:///com/github/Aylur/ags/widget.js';

import EventBox from '../misc/cursorbox.js';


export default () => EventBox({
    child: ToggleButton({
        setup: self => {
            // Open at startup if there are players
            const id = Mpris.connect('changed', () => {
                self.set_active(Mpris.players.length > 0);
                Mpris.disconnect(id);
            });
        },

        connections: [['toggled', self => {
            const rev = self.get_parent().get_parent().get_parent().children[1];

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
        }]],

        child: Icon({
            icon: App.configDir + '/icons/down-large.svg',
            className: 'arrow',
            css: '-gtk-icon-transform: rotate(180deg);',
        }),
    }),
});

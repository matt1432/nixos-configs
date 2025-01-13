import { App, Astal, Gdk, Gtk } from 'astal/gtk4';
import { Variable } from 'astal';

import Kompass from 'gi://Kompass';

import { Box, Calendar, CenterBox, Label, MenuButton, Popover, Window } from './subclasses';

const { EXCLUSIVE } = Astal.Exclusivity;
const { TOP, LEFT, RIGHT } = Astal.WindowAnchor;
const { CENTER } = Gtk.Align;

const time = Variable(0);

setInterval(() => {
    time.set(time.get() + 1);
}, 1000);

export default () => {
    const styledBox = Box({
        css: time().as((t) => `* { background: red; min-height: 10px; min-width: ${t}px; }`),
    });

    return Window({
        visible: true,
        cssClasses: ['Bar'],
        exclusivity: EXCLUSIVE,
        anchor: TOP | LEFT | RIGHT,
        application: App,

        child: CenterBox({
            startWidget: new Kompass.Tray({
                cursor: Gdk.Cursor.new_from_name('pointer', null),
            }),

            centerWidget: styledBox,

            endWidget: MenuButton({
                cursor: Gdk.Cursor.new_from_name('pointer', null),
                hexpand: true,
                halign: CENTER,

                children: [
                    Label({ label: time().as(String) }),
                    Popover({ child: Calendar() }),
                ],
            }),
        }),
    });
};

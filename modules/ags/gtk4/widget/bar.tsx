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
    const styledBox = (
        <Box
            css={time().as((t) => `* { background: red; min-height: 10px; min-width: ${t}px; }`)}
        />
    ) as Box;

    return (
        <Window
            visible
            cssClasses={['Bar']}
            exclusivity={EXCLUSIVE}
            anchor={TOP | LEFT | RIGHT}
            application={App}
        >
            <CenterBox cssName="centerbox">
                <Kompass.Tray cursor={Gdk.Cursor.new_from_name('pointer', null)} />

                {styledBox}

                <MenuButton
                    cursor={Gdk.Cursor.new_from_name('pointer', null)}
                    hexpand
                    halign={CENTER}
                >
                    <Label label={time().as(String)} />
                    <Popover>
                        <Calendar />
                    </Popover>
                </MenuButton>
            </CenterBox>
        </Window>
    );
};

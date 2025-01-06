import { App, Astal, Gtk } from 'astal/gtk4';
import { Variable } from 'astal';

import Kompass from 'gi://Kompass';

import { Box, Button, Calendar, CenterBox, Label, MenuButton, Popover, Window } from './subclasses';

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
                <Kompass.Tray />

                {styledBox}

                <MenuButton
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

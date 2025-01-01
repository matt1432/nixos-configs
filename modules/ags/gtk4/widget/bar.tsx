import { App, Astal, Gtk } from 'astal/gtk4';
import { Variable } from 'astal';

import { Box, Button, CenterBox } from './subclasses';

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
        <window
            visible
            cssClasses={['Bar']}
            exclusivity={EXCLUSIVE}
            anchor={TOP | LEFT | RIGHT}
            application={App}
        >
            <CenterBox cssName="centerbox">
                <Button onClicked="echo hi" />

                {styledBox}

                <menubutton
                    hexpand
                    halign={CENTER}
                >
                    <label label={time().as(String)} />
                    <popover>
                        <Gtk.Calendar />
                    </popover>
                </menubutton>
            </CenterBox>
        </window>
    );
};

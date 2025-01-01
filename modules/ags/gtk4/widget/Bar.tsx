import { App, Astal, Gtk } from 'astal/gtk4';
import { Variable } from 'astal';

import { StyledBox } from './styled-box';

const { EXCLUSIVE } = Astal.Exclusivity;
const { TOP, LEFT, RIGHT } = Astal.WindowAnchor;
const { CENTER } = Gtk.Align;


const time = Variable(0);

setInterval(() => {
    time.set(time.get() + 1);
}, 1000);

export default () => {
    const styledBox = (
        <StyledBox
            css={time().as((t) => `* { background: red; min-height: 10px; min-width: ${t}px; }`)}
        />
    ) as StyledBox;

    return (
        <window
            visible
            cssClasses={['Bar']}
            exclusivity={EXCLUSIVE}
            anchor={TOP | LEFT | RIGHT}
            application={App}
        >
            <centerbox cssName="centerbox">
                <box />

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
            </centerbox>
        </window>
    );
};

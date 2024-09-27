import { Astal, Gtk } from 'astal';

import Battery from './items/battery';

import BarRevealer from './fullscreen';


export default () => {
    return (
        <BarRevealer
            exclusivity={Astal.Exclusivity.EXCLUSIVE}
            anchor={
                Astal.WindowAnchor.TOP |
                Astal.WindowAnchor.LEFT |
                Astal.WindowAnchor.RIGHT
            }
        >
            <centerbox className="bar widget">
                <box hexpand halign={Gtk.Align.START}>
                </box>

                <box>
                </box>

                <box hexpand halign={Gtk.Align.END}>
                    <Battery />
                </box>
            </centerbox>
        </BarRevealer>
    );
};

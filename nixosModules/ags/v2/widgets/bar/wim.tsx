import { Astal, Gtk } from 'astal';

import Battery from './items/battery';
import CurrentClient from './items/current-client';

import BarRevealer from './fullscreen';
import Separator from '../misc/separator';


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
                    <CurrentClient />
                </box>

                <box>
                </box>

                <box hexpand halign={Gtk.Align.END}>
                    <Battery />

                    <Separator size={2} />
                </box>
            </centerbox>

        </BarRevealer>
    );
};

import { Astal, Gtk } from 'astal';

import Battery from './items/battery';
import Clock from './items/clock';
import CurrentClient from './items/current-client';
import Workspaces from './items/workspaces';

import BarRevealer from './fullscreen';
import Separator from '../misc/separator';


export default () => (
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
                <Workspaces />

                <Separator size={8} />

                <CurrentClient />
            </box>

            <box>
                <Clock />
            </box>

            <box hexpand halign={Gtk.Align.END}>
                <Battery />

                <Separator size={2} />
            </box>
        </centerbox>

    </BarRevealer>
);

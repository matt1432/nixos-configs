import { Astal, Gtk } from 'astal/gtk3';

import Battery from './items/battery';
import Clock from './items/clock';
import CurrentClient from './items/current-client';
import NotifButton from './items/notif-button';
import SysTray from './items/tray';
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

                <SysTray />

                <Separator size={8} />

                <CurrentClient />

                <Separator size={8} />
            </box>

            <box>
                <Clock />
            </box>

            <box hexpand halign={Gtk.Align.END}>
                <NotifButton />

                <Separator size={8} />

                <Battery />

                <Separator size={2} />
            </box>
        </centerbox>

    </BarRevealer>
);

import { Astal, Gtk } from 'astal/gtk3';

import Audio from './items/audio';
import Clock from './items/clock';
import CurrentIcon from './items/current-icon';
import Network from './items/network';
import NotifButton from './items/notif-button';
import SysTray from './items/tray';

import BarRevealer from './fullscreen';
import Separator from '../misc/separator';
import { get_gdkmonitor_from_desc } from '../../lib';


export default () => (
    <BarRevealer
        gdkmonitor={get_gdkmonitor_from_desc('desc:Acer Technologies Acer K212HQL T3EAA0014201')}
        exclusivity={Astal.Exclusivity.EXCLUSIVE}
        anchor={
            Astal.WindowAnchor.BOTTOM |
            Astal.WindowAnchor.LEFT |
            Astal.WindowAnchor.RIGHT
        }
    >
        <centerbox className="bar widget">
            <box hexpand halign={Gtk.Align.START}>
                <CurrentIcon />

                {/* <Separator size={8} />*/}

                <SysTray />

                <Separator size={8} />
            </box>

            <box>
                <Clock />
            </box>

            <box hexpand halign={Gtk.Align.END}>
                <Network />

                <Separator size={8} />

                <NotifButton />

                <Separator size={8} />

                <Audio />

                <Separator size={2} />
            </box>
        </centerbox>

    </BarRevealer>
);

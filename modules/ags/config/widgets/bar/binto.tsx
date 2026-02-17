import { Astal, Gtk } from 'ags/gtk3';

import { get_gdkmonitor_from_desc } from '../../lib';
import Separator from '../misc/separator';
import Audio from './items/audio';
import Clock from './items/clock';
import CurrentIcon from './items/current-icon';
import Network from './items/network';
import NotifButton from './items/notif-button';
import SysTray from './items/tray';

export default () => (
    <window
        name="noanim-bar"
        namespace="noanim-bar"
        layer={Astal.Layer.OVERLAY}
        gdkmonitor={get_gdkmonitor_from_desc(
            'desc:GIGA-BYTE TECHNOLOGY CO. LTD. G27QC 0x00000B1D',
        )}
        exclusivity={Astal.Exclusivity.EXCLUSIVE}
        anchor={
            Astal.WindowAnchor.BOTTOM |
            Astal.WindowAnchor.LEFT |
            Astal.WindowAnchor.RIGHT
        }
    >
        <centerbox class="bar binto widget">
            <box $type="start" hexpand halign={Gtk.Align.START}>
                <CurrentIcon />

                {/* <Separator size={8} />*/}

                <SysTray />

                <Separator size={8} />
            </box>

            <box $type="center">
                <Clock />
            </box>

            <box $type="end" hexpand halign={Gtk.Align.END}>
                <Network />

                <Separator size={8} />

                <NotifButton />

                <Separator size={8} />

                <Audio />

                <Separator size={2} />
            </box>
        </centerbox>
    </window>
);

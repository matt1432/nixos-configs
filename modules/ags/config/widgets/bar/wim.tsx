import { bind } from 'astal';
import { Astal, Gtk } from 'astal/gtk3';

import Audio from './items/audio';
import Battery from './items/battery';
import Bluetooth from './items/bluetooth';
import Brightness from './items/brightness';
import Clock from './items/clock';
import CurrentClient from './items/current-client';
import Network from './items/network';
import NotifButton from './items/notif-button';
import SysTray from './items/tray';
import Workspaces from './items/workspaces';

import BarRevealer from './fullscreen';
import Separator from '../misc/separator';
import Tablet from '../../services/tablet';


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

                <button
                    className="bar-item tablet-mode"
                    cursor="pointer"

                    onButtonReleaseEvent={() => {
                        const tablet = Tablet.get_default();

                        tablet.toggleMode();
                    }}
                >
                    <icon
                        icon={bind(Tablet.get_default(), 'currentMode')
                            .as((mode) => `${mode}-symbolic`)}
                    />
                </button>

                <CurrentClient />

                <Separator size={8} />
            </box>

            <box>
                <Clock />
            </box>

            <box hexpand halign={Gtk.Align.END}>
                <Network />

                <Separator size={8} />

                <Bluetooth />

                <Separator size={8} />

                <NotifButton />

                <Separator size={8} />

                <Audio />

                <Separator size={8} />

                <Brightness />

                <Separator size={8} />

                <Battery />

                <Separator size={2} />
            </box>
        </centerbox>

    </BarRevealer>
);

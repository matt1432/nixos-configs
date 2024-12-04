import { bind } from 'astal';
import { Gtk, Widget } from 'astal/gtk3';

import AstalBluetooth from 'gi://AstalBluetooth';

import Separator from '../misc/separator';


export default (dev: AstalBluetooth.Device) => {
    const rev = (
        <revealer
            transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}
        >
            <box>
                TODO: add buttons here
            </box>
        </revealer>
    ) as Widget.Revealer;

    const button = (
        <button
            onButtonReleaseEvent={() => {
                rev.revealChild = !rev.revealChild;
            }}
        >
            <box>
                <icon
                    icon={bind(dev, 'connected').as((isConnected) => isConnected ?
                        'check-active-symbolic' :
                        'check-mixed-symbolic')}

                    css={bind(dev, 'paired').as((isPaired) => isPaired ?
                        '' :
                        'opacity: 0;')}
                />

                <Separator size={8} />

                <icon
                    icon={bind(dev, 'icon').as((iconName) =>
                        iconName ? `${iconName}-symbolic` : 'help-browser-symbolic')}
                />

                <Separator size={8} />

                <label label={bind(dev, 'name')} />
            </box>
        </button>
    );

    return (
        <box vertical>
            {button}
            {rev}
        </box>
    );
};

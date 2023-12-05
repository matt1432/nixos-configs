import Network from 'resource:///com/github/Aylur/ags/service/network.js';

import { Label, Box, EventBox, Icon, Revealer } from 'resource:///com/github/Aylur/ags/widget.js';

import Separator from '../../misc/separator.js';


const Indicator = (props) => Icon({
    ...props,
    connections: [[Network, (self) => {
        if (Network.wifi.internet === 'connected' ||
            Network.wifi.internet === 'connecting') {
            self.icon = Network.wifi.iconName;
        }
        else if (Network.wired.internet === 'connected' ||
                 Network.wired.internet === 'connecting') {
            self.icon = Network.wired.iconName;
        }
        else {
            self.icon = Network.wifi.iconName;
        }
    }]],
});

const APLabel = (props) => Label({
    ...props,
    connections: [[Network, (self) => {
        if (Network.wifi.internet === 'connected' ||
            Network.wifi.internet === 'connecting') {
            self.label = Network.wifi.ssid;
        }
        else if (Network.wired.internet === 'connected' ||
                 Network.wired.internet === 'connecting') {
            self.label = 'Connected';
        }
        else {
            self.label = 'Disconnected';
        }
    }]],
});

const SPACING = 5;

export default () => {
    const rev = Revealer({
        transition: 'slide_right',
        child: Box({
            children: [
                Separator(SPACING),
                APLabel(),
            ],
        }),
    });

    const widget = EventBox({
        onHover: () => {
            rev.revealChild = true;
        },
        onHoverLost: () => {
            rev.revealChild = false;
        },
        child: Box({
            className: 'network',
            children: [
                Indicator(),

                rev,
            ],
        }),
    });

    widget.rev = rev;

    return widget;
};

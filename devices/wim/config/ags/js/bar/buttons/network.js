import Network from 'resource:///com/github/Aylur/ags/service/network.js';

import { Label, Box, EventBox, Icon, Revealer } from 'resource:///com/github/Aylur/ags/widget.js';

import Separator from '../../misc/separator.js';

const SPACING = 5;


export default () => {
    const indicator = Icon().hook(Network, (self) => {
        if (Network.wifi.internet === 'connected' ||
            Network.wifi.internet === 'connecting') {
            self.icon = Network.wifi.icon_name;
        }
        else if (Network.wired.internet === 'connected' ||
                 Network.wired.internet === 'connecting') {
            self.icon = Network.wired.icon_name;
        }
        else {
            self.icon = Network.wifi.icon_name;
        }
    });

    const label = Label().hook(Network, (self) => {
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
    });

    const hoverRevLabel = Revealer({
        transition: 'slide_right',
        child: Box({
            children: [
                Separator(SPACING),
                label,
            ],
        }),
    });

    const widget = EventBox({
        on_hover: () => {
            hoverRevLabel.reveal_child = true;
        },
        on_hover_lost: () => {
            hoverRevLabel.reveal_child = false;
        },

        child: Box({
            class_name: 'network',

            children: [
                indicator,

                hoverRevLabel,
            ],
        }),
    });

    return widget;
};

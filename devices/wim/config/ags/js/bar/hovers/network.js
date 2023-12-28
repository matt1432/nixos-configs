import Network from 'resource:///com/github/Aylur/ags/service/network.js';

import { Label, Icon } from 'resource:///com/github/Aylur/ags/widget.js';

import HoverRevealer from './hover-revealer.js';


export default () => HoverRevealer({
    class_name: 'network',

    icon: Icon().hook(Network, (self) => {
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
    }),

    label: Label().hook(Network, (self) => {
        if (Network.wifi.internet === 'connected' ||
            Network.wifi.internet === 'connecting') {
            self.label = Network.wifi.ssid || 'Unknown';
        }
        else if (Network.wired.internet === 'connected' ||
                 Network.wired.internet === 'connecting') {
            self.label = 'Connected';
        }
        else {
            self.label = 'Disconnected';
        }
    }),
});

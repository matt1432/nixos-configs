import { Box, Icon, Label } from 'resource:///com/github/Aylur/ags/widget.js';


export default () => Box({
    className: 'osd',
    children: [
        Icon({
            hpack: 'start',
            icon: 'caps-lock-symbolic',
            connections: [[Brightness, (self, state) => {
                self.icon = state ? 'caps-lock-symbolic' : 'capslock-disabled-symbolic';

                const stack = self.get_parent().get_parent();
                stack.shown = 'caps';
                stack.resetTimer();
            }, 'caps']],
        }),

        Label({
            vpack: 'center',
            label: 'Caps Lock',
        }),
    ],
});

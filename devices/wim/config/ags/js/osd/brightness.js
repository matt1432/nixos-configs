import { Box, Icon, ProgressBar } from 'resource:///com/github/Aylur/ags/widget.js';


export default () => Box({
    className: 'osd',
    children: [
        Icon({
            hpack: 'start',
            icon: 'display-brightness-symbolic',
        }),

        ProgressBar({
            vpack: 'center',
            connections: [[Brightness, self => {
                self.value = Brightness.screen;

                const stack = self.get_parent().get_parent();
                stack.shown = 'brightness';
                stack.resetTimer();
            }, 'screen']],
        }),
    ],
});

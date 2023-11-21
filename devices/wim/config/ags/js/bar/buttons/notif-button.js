import App from 'resource:///com/github/Aylur/ags/app.js';
import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';

import { Box, Icon, Label } from 'resource:///com/github/Aylur/ags/widget.js';

import Separator from '../../misc/separator.js';
import EventBox from '../../misc/cursorbox.js';

const L_PADDING = 28;
const R_PADDING = 8;


export default () => EventBox({
    className: 'toggle-off',

    onPrimaryClickRelease: () => App.toggleWindow('notification-center'),

    connections: [[App, (self, windowName, visible) => {
        if (windowName === 'notification-center') {
            self.toggleClassName('toggle-on', visible);
        }
    }]],

    child: Box({
        className: 'notif-panel',
        vertical: false,

        children: [
            Separator(L_PADDING),

            Icon({
                connections: [[Notifications, (self) => {
                    if (Notifications.dnd) {
                        self.icon = 'notification-disabled-symbolic';
                    }
                    else if (Notifications.notifications.length > 0) {
                        self.icon = 'notification-new-symbolic';
                    }
                    else {
                        self.icon = 'notification-symbolic';
                    }
                }]],
            }),

            Separator(R_PADDING),

            Label({
                binds: [['label', Notifications, 'notifications',
                    (n) => String(n.length)]],
            }),

        ],
    }),
});

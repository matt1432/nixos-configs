import App from 'resource:///com/github/Aylur/ags/app.js';
import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';

import { Box, CenterBox, Icon, Label } from 'resource:///com/github/Aylur/ags/widget.js';

import EventBox from '../../misc/cursorbox.js';
import Separator from '../../misc/separator.js';

const SPACING = 4;


export default () => EventBox({
    className: 'toggle-off',

    onPrimaryClickRelease: (self) => {
        App.getWindow('notification-center')
            .setXPos(self.get_allocation(), 'right');

        App.toggleWindow('notification-center');
    },

    setup: (self) => {
        self.hook(App, (_, windowName, visible) => {
            if (windowName === 'notification-center') {
                self.toggleClassName('toggle-on', visible);
            }
        });
    },

    child: CenterBox({
        className: 'notif-panel',

        center_widget: Box({
            children: [
                Icon({
                    setup: (self) => {
                        self.hook(Notifications, () => {
                            if (Notifications.dnd) {
                                self.icon = 'notification-disabled-symbolic';
                            }
                            else if (Notifications.notifications.length > 0) {
                                self.icon = 'notification-new-symbolic';
                            }
                            else {
                                self.icon = 'notification-symbolic';
                            }
                        });
                    },
                }),

                Separator(SPACING),

                Label({
                    binds: [['label', Notifications, 'notifications',
                        (n) => String(n.length)]],
                }),
            ],
        }),
    }),
});

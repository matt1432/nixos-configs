import App from 'resource:///com/github/Aylur/ags/app.js';
import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';

import { Box, CenterBox, Icon, Label } from 'resource:///com/github/Aylur/ags/widget.js';

import CursorBox from '../../misc/cursorbox.ts';
import Separator from '../../misc/separator.ts';

const SPACING = 4;

// Types
import AgsWindow from 'types/widgets/window.ts';


export default () => CursorBox({
    class_name: 'toggle-off',

    on_primary_click_release: (self) => {
        (App.getWindow('notification-center') as AgsWindow)
            ?.attribute.set_x_pos(
                self.get_allocation(),
                'right',
            );

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
        class_name: 'notif-panel',

        center_widget: Box({
            children: [
                Icon().hook(Notifications, (self) => {
                    if (Notifications.dnd) {
                        self.icon = 'notification-disabled-symbolic';
                    }
                    else if (Notifications.notifications.length > 0) {
                        self.icon = 'notification-new-symbolic';
                    }
                    else {
                        self.icon = 'notification-symbolic';
                    }
                }),

                Separator(SPACING),

                Label({
                    label: Notifications.bind('notifications')
                        .transform((n) => String(n.length)),
                }),
            ],
        }),
    }),
});

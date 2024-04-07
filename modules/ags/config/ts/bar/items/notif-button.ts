const Notifications = await Service.import('notifications');
const { Box, CenterBox, Icon, Label } = Widget;

import CursorBox from '../../misc/cursorbox.ts';
import Separator from '../../misc/separator.ts';

const SPACING = 4;

// Types
import { PopupWindow } from 'global-types';


export default () => CursorBox({
    class_name: 'toggle-off',

    on_primary_click_release: (self) => {
        (App.getWindow('win-notification-center') as PopupWindow)
            .set_x_pos(
                self.get_allocation(),
                'right',
            );

        App.toggleWindow('win-notification-center');
    },

    setup: (self) => {
        self.hook(App, (_, windowName, visible) => {
            if (windowName === 'win-notification-center') {
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

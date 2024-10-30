import { bind } from 'astal';
import { App } from 'astal/gtk3';

import AstalNotifd from 'gi://AstalNotifd';
const Notifications = AstalNotifd.get_default();

import Separator from '../../misc/separator';

const SPACING = 4;

// Types
import PopupWindow from '../../misc/popup-window';


export default () => (
    <button
        className="bar-item"
        cursor="pointer"

        onButtonReleaseEvent={(self) => {
            const win = App.get_window('win-notif-center') as PopupWindow;

            win.set_x_pos(
                self.get_allocation(),
                'right',
            );

            win.visible = !win.visible;
        }}

        setup={(self) => {
            App.connect('window-toggled', (_, win) => {
                if (win.name === 'win-notif-center') {
                    self.toggleClassName('toggle-on', win.visible);
                }
            });
        }}
    >
        <box>
            <icon
                icon={bind(Notifications, 'notifications').as((notifs) => {
                    if (Notifications.dontDisturb) {
                        return 'notification-disabled-symbolic';
                    }
                    else if (notifs.length > 0) {
                        return 'notification-new-symbolic';
                    }
                    else {
                        return 'notification-symbolic';
                    }
                })}
            />

            <Separator size={SPACING} />

            <label label={bind(Notifications, 'notifications').as((n) => String(n.length))} />
        </box>
    </button>
);

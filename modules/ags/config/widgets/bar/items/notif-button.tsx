import { bind } from 'astal';
import { App } from 'astal/gtk3';
import AstalNotifd from 'gi://AstalNotifd';

import { getWindow } from '../../../lib';
import Separator from '../../misc/separator';

const SPACING = 4;

export default () => {
    const notifications = AstalNotifd.get_default();

    return (
        <button
            className="bar-item"
            cursor="pointer"
            onButtonReleaseEvent={(self) => {
                const win = getWindow('win-notif-center')!;

                win.set_x_pos(self.get_allocation(), 'right');

                win.set_visible(!win.get_visible());
            }}
            setup={(self) => {
                App.connect('window-toggled', (_, win) => {
                    if (win.get_name()?.startsWith('win-notif-center')) {
                        self.toggleClassName('toggle-on', win.get_visible());
                    }
                });
            }}
        >
            <box>
                <icon
                    icon={bind(notifications, 'notifications').as((notifs) => {
                        if (notifications.get_dont_disturb()) {
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

                <label
                    label={bind(notifications, 'notifications').as((n) =>
                        String(n.length),
                    )}
                />
            </box>
        </button>
    );
};

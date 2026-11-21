import { createBinding } from 'ags';
import app from 'ags/gtk4/app';
import AstalNotifd from 'gi://AstalNotifd';

import { getWindow } from '../../../lib';
import { pointer, toggleClassName } from '../../../lib/widgets';
import Separator from '../../misc/separator';

const SPACING = 4;

export default () => {
    const notifications = AstalNotifd.get_default();

    return (
        <button
            class="bar-item"
            cursor={pointer}
            onClicked={(self) => {
                const win = getWindow('win-notif-center')!;

                win.set_x_pos(self, 'right');

                win.set_visible(!win.get_visible());
            }}
            $={(self) => {
                app.connect('window-toggled', (_, win) => {
                    if (win.get_name()?.startsWith('win-notif-center')) {
                        toggleClassName(self, 'toggle-on', win.get_visible());
                    }
                });
            }}
        >
            <box>
                <image
                    iconName={createBinding(notifications, 'notifications').as(
                        (notifs) => {
                            if (notifications.get_dont_disturb()) {
                                return 'notification-disabled-symbolic';
                            }
                            else if (notifs.length > 0) {
                                return 'notification-new-symbolic';
                            }
                            else {
                                return 'notification-symbolic';
                            }
                        },
                    )}
                />

                <Separator size={SPACING} />

                <label
                    label={createBinding(notifications, 'notifications').as(
                        (n) => String(n.length),
                    )}
                />
            </box>
        </button>
    );
};

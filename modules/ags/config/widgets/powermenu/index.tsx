import { Astal, Gtk } from 'ags/gtk3';
import { execAsync } from 'ags/process';

import { hyprMessage } from '../../lib';
import PopupWindow from '../misc/popup-window';

const PowermenuWidget = () => {
    const label = (<label />) as Astal.Label;

    const content = [
        <box $type="named" name="buttons">
            <cursor-button
                class="shutdown button"
                cursor="pointer"
                onButtonReleaseEvent={(self) => {
                    label.set_label('Shutting down...');
                    (self.get_parent()?.get_parent() as Astal.Stack).set_shown(
                        'message',
                    );
                    execAsync(['systemctl', 'poweroff']).catch(print);
                }}
            >
                <icon icon="system-shutdown-symbolic" />
            </cursor-button>

            <cursor-button
                class="reboot button"
                cursor="pointer"
                onButtonReleaseEvent={(self) => {
                    label.set_label('Rebooting...');
                    (self.get_parent()?.get_parent() as Astal.Stack).set_shown(
                        'message',
                    );
                    execAsync(['systemctl', 'reboot']).catch(print);
                }}
            >
                <icon icon="system-restart-symbolic" />
            </cursor-button>

            <cursor-button
                class="logout button"
                cursor="pointer"
                onButtonReleaseEvent={(self) => {
                    label.set_label('Logging out...');
                    (self.get_parent()?.get_parent() as Astal.Stack).set_shown(
                        'message',
                    );
                    hyprMessage('dispatch exit').catch(print);
                }}
            >
                <icon icon="system-log-out-symbolic" />
            </cursor-button>
        </box>,

        <box
            $type="named"
            name="message"
            hexpand={false}
            halign={Gtk.Align.CENTER}
        >
            {label}
        </box>,
    ] as Gtk.Widget[];

    return (
        <centerbox class="powermenu widget">
            <stack
                $type="center"
                transitionType={Gtk.StackTransitionType.SLIDE_DOWN}
            >
                {content}
            </stack>
        </centerbox>
    );
};

export default () => (
    <PopupWindow
        name="powermenu"
        transition="slide bottom"
        // To put it at the center of the screen
        exclusivity={Astal.Exclusivity.IGNORE}
    >
        <PowermenuWidget />
    </PopupWindow>
);

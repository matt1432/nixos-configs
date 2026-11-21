import { Astal, Gtk } from 'ags/gtk4';
import { execAsync } from 'ags/process';

import { hyprMessage } from '../../lib';
import { pointer } from '../../lib/widgets';
import PopupWindow from '../misc/popup-window';

const PowermenuWidget = () => {
    const label = (<label />) as Gtk.Label;

    const showMessage = (message: string) => {
        label.set_label(message);
        stack.set_visible_child_name('message');
    };

    const content = [
        <box $type="named" name="buttons">
            <button
                class="shutdown button"
                cursor={pointer}
                onClicked={() => {
                    showMessage('Shutting down...');
                    execAsync(['systemctl', 'poweroff']).catch(print);
                }}
            >
                <image iconName="system-shutdown-symbolic" />
            </button>

            <button
                class="reboot button"
                cursor={pointer}
                onClicked={() => {
                    showMessage('Rebooting...');
                    execAsync(['systemctl', 'reboot']).catch(print);
                }}
            >
                <image iconName="system-restart-symbolic" />
            </button>

            <button
                class="logout button"
                cursor={pointer}
                onClicked={() => {
                    showMessage('Logging out...');
                    hyprMessage('dispatch hl.dsp.exit()').catch(print);
                }}
            >
                <image iconName="system-log-out-symbolic" />
            </button>
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

    const stack = (
        <stack
            $type="center"
            transitionType={Gtk.StackTransitionType.SLIDE_DOWN}
        >
            {content}
        </stack>
    ) as Gtk.Stack;

    return <centerbox class="powermenu widget">{stack}</centerbox>;
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

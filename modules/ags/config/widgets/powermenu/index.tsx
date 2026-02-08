import { execAsync } from 'astal';
import { Astal, Gtk } from 'astal/gtk3';

import { hyprMessage } from '../../lib';
import PopupWindow from '../misc/popup-window';

const PowermenuWidget = () => {
    const label = (<label />) as Astal.Label;

    return (
        <centerbox className="powermenu widget">
            <stack transitionType={Gtk.StackTransitionType.SLIDE_DOWN}>
                <box name="buttons">
                    <button
                        className="shutdown button"
                        cursor="pointer"
                        onButtonReleaseEvent={(self) => {
                            label.set_label('Shutting down...');
                            (
                                self.get_parent()?.get_parent() as Astal.Stack
                            ).set_shown('message');
                            execAsync(['systemctl', 'poweroff']).catch(print);
                        }}
                    >
                        <icon icon="system-shutdown-symbolic" />
                    </button>

                    <button
                        className="reboot button"
                        cursor="pointer"
                        onButtonReleaseEvent={(self) => {
                            label.set_label('Rebooting...');
                            (
                                self.get_parent()?.get_parent() as Astal.Stack
                            ).set_shown('message');
                            execAsync(['systemctl', 'reboot']).catch(print);
                        }}
                    >
                        <icon icon="system-restart-symbolic" />
                    </button>

                    <button
                        className="logout button"
                        cursor="pointer"
                        onButtonReleaseEvent={(self) => {
                            label.set_label('Logging out...');
                            (
                                self.get_parent()?.get_parent() as Astal.Stack
                            ).set_shown('message');
                            hyprMessage('dispatch exit').catch(print);
                        }}
                    >
                        <icon icon="system-log-out-symbolic" />
                    </button>
                </box>

                <box name="message" hexpand={false} halign={Gtk.Align.CENTER}>
                    {label}
                </box>
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

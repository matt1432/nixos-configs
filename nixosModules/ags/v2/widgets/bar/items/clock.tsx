import { bind, Variable } from 'astal';
import { App } from 'astal/gtk3';

import GLib from 'gi://GLib';
import PopupWindow from '../../misc/popup-window';


export default () => {
    const timeVar = Variable<string>('').poll(1000, (prev) => {
        const time = GLib.DateTime.new_now_local();

        const dayName = time.format('%a. ');
        const dayNum = time.get_day_of_month();
        const date = time.format(' %b. ');
        const hour = (new Date().toLocaleString([], {
            hour: 'numeric',
            minute: 'numeric',
            hour12: true,
        }) ?? '')
            .replace('a.m.', 'AM')
            .replace('p.m.', 'PM');

        return (dayNum && dayName && date) ?
            (dayName + dayNum + date + hour) :
            prev;
    });

    return (
        <button
            className="bar-item"
            cursor="pointer"

            onButtonReleaseEvent={(self) => {
                const win = App.get_window('win-calendar') as PopupWindow;

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
            <label label={bind(timeVar)} />
        </button>
    );
};

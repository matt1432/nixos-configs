import { bind, Variable } from 'astal';

import GLib from 'gi://GLib?version=2.0';


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
        <box className="bar-item">
            <label label={bind(timeVar)} />
        </box>
    );
};

import { bind, Variable } from 'astal';
import { Gtk } from 'astal/gtk3';

import GLib from 'gi://GLib';


const Divider = () => (
    <box
        className="divider"
        vertical
    />
);

const Time = () => {
    const hour = Variable<string>('').poll(1000, () => GLib.DateTime.new_now_local().format('%H') || '');
    const min = Variable<string>('').poll(1000, () => GLib.DateTime.new_now_local().format('%M') || '');

    const fullDate = Variable<string>('').poll(1000, () => {
        const time = GLib.DateTime.new_now_local();

        const dayNameMonth = time.format('%A, %B ');
        const dayNum = time.get_day_of_month();
        const date = time.format(', %Y');

        return dayNum && dayNameMonth && date ?
            dayNameMonth + dayNum + date :
            '';
    });

    return (
        <box
            className="timebox"
            vertical
        >
            <box
                className="time-container"
                halign={Gtk.Align.CENTER}
                valign={Gtk.Align.CENTER}
            >
                <label
                    className="content"
                    label={bind(hour)}
                />

                <Divider />

                <label
                    className="content"
                    label={bind(min)}
                />
            </box>

            <box
                className="date-container"
                halign={Gtk.Align.CENTER}
            >
                <label
                    css="font-size: 20px;"
                    label={bind(fullDate)}
                />
            </box>
        </box>
    );
};

export default () => {
    const cal = new Gtk.Calendar({
        show_day_names: true,
        show_heading: true,
    });

    cal.show_all();

    return (
        <box
            className="date widget"
            vertical
        >
            <Time />

            <box className="cal-box">
                {cal}
            </box>
        </box>
    );
};

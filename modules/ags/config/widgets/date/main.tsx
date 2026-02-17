import { Gtk } from 'ags/gtk3';
import { createPoll } from 'ags/time';
import GLib from 'gi://GLib';

const Divider = () => <box class="divider" vertical />;

const Time = () => {
    const hour = createPoll(
        '',
        1000,
        () => GLib.DateTime.new_now_local().format('%H') || '',
    );
    const min = createPoll(
        '',
        1000,
        () => GLib.DateTime.new_now_local().format('%M') || '',
    );

    const fullDate = createPoll('', 1000, () => {
        const time = GLib.DateTime.new_now_local();

        const dayNameMonth = time.format('%A, %B ');
        const dayNum = time.get_day_of_month();
        const date = time.format(', %Y');

        return dayNum && dayNameMonth && date
            ? dayNameMonth + dayNum + date
            : '';
    });

    return (
        <box class="timebox" vertical>
            <box
                class="time-container"
                halign={Gtk.Align.CENTER}
                valign={Gtk.Align.CENTER}
            >
                <label class="content" label={hour} />

                <Divider />

                <label class="content" label={min} />
            </box>

            <box class="date-container" halign={Gtk.Align.CENTER}>
                <label css="font-size: 20px;" label={fullDate} />
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
        <box class="date widget" vertical>
            <Time />

            <box class="cal-box">{cal}</box>
        </box>
    );
};

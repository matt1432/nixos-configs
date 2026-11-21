import { Gtk } from 'ags/gtk4';
import { createPoll } from 'ags/time';
import GLib from 'gi://GLib';

import { pointer } from '../../lib/widgets';

const Divider = () => (
    <box class="divider" orientation={Gtk.Orientation.VERTICAL} />
);

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
        <box class="timebox" orientation={Gtk.Orientation.VERTICAL}>
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

export default () => (
    <box class="date widget" orientation={Gtk.Orientation.VERTICAL}>
        <Time />

        <box class="cal-box">
            <Gtk.Calendar
                showDayNames
                showHeading
                $={(self) => {
                    // The arrows and days are internal widgets, so set the cursor
                    // on the clickable ones directly
                    const setCursors = (widget: Gtk.Widget) => {
                        if (
                            widget instanceof Gtk.Button ||
                            widget.has_css_class('day-number')
                        ) {
                            widget.set_cursor(pointer);
                        }

                        for (
                            let child = widget.get_first_child();
                            child;
                            child = child.get_next_sibling()
                        ) {
                            setCursors(child);
                        }
                    };

                    setCursors(self);
                }}
            />
        </box>
    </box>
);

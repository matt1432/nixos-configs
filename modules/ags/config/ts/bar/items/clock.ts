import { Label } from 'resource:///com/github/Aylur/ags/widget.js';
const { new_now_local } = imports.gi.GLib.DateTime;


export default () => Label({ class_name: 'clock' })
    .poll(1000, (self) => {
        const time = new_now_local();

        const dayName = time.format('%a. ');
        const dayNum = time.get_day_of_month();
        const date = time.format(' %b. %H:%M');

        if (dayNum && dayName && date) {
            self.label = dayName + dayNum + date;
        }
    });

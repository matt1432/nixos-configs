import { Label } from 'resource:///com/github/Aylur/ags/widget.js';


export default () => Label({ className: 'clock' })
    .poll(1000, (self) => {
        const time = imports.gi.GLib
            .DateTime.new_now_local();

        self.label = time.format('%a. ') +
            time.get_day_of_month() +
            time.format(' %b. %H:%M');
    });

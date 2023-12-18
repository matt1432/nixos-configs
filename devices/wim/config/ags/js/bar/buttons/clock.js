import App from 'resource:///com/github/Aylur/ags/app.js';

import { Label } from 'resource:///com/github/Aylur/ags/widget.js';

const { DateTime } = imports.gi.GLib;

import EventBox from '../../misc/cursorbox.js';


export default () => EventBox({
    className: 'toggle-off',

    onPrimaryClickRelease: () => App.toggleWindow('calendar'),

    setup: (self) => {
        self.hook(App, (_, windowName, visible) => {
            if (windowName === 'calendar') {
                self.toggleClassName('toggle-on', visible);
            }
        });
    },

    child: Label({ class_name: 'clock' })
        .poll(1000, (self) => {
            const time = DateTime.new_now_local();

            self.label = time.format('%a. ') +
                time.get_day_of_month() +
                time.format(' %b. %H:%M');
        }),
});

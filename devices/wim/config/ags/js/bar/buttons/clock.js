import App from 'resource:///com/github/Aylur/ags/app.js';

import { Label } from 'resource:///com/github/Aylur/ags/widget.js';

import GLib from 'gi://GLib';
const { DateTime } = GLib;

import EventBox from '../../misc/cursorbox.js';


const ClockModule = () => Label({
    className: 'clock',

    setup: (self) => {
        self.poll(1000, () => {
            const time = DateTime.new_now_local();

            self.label = time.format('%a. ') +
                time.get_day_of_month() +
                time.format(' %b. %H:%M');
        });
    },
});

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

    child: ClockModule(),
});

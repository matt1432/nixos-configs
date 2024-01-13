import { Box, Calendar, Label } from 'resource:///com/github/Aylur/ags/widget.js';

const { DateTime } = imports.gi.GLib;

import PopupWindow from './misc/popup.js';


const Divider = () => Box({
    class_name: 'divider',
    vertical: true,
});

const Time = () => Box({
    class_name: 'timebox',
    vertical: true,

    children: [
        Box({
            class_name: 'time-container',
            hpack: 'center',
            vpack: 'center',

            children: [
                Label({
                    class_name: 'content',
                    label: 'hour',
                    setup: (self) => {
                        self.poll(1000, () => {
                            self.label = DateTime.new_now_local().format('%H');
                        });
                    },
                }),

                Divider(),

                Label({
                    class_name: 'content',
                    label: 'minute',
                    setup: (self) => {
                        self.poll(1000, () => {
                            self.label = DateTime.new_now_local().format('%M');
                        });
                    },
                }),

            ],
        }),

        Box({
            class_name: 'date-container',
            hpack: 'center',

            child: Label({
                css: 'font-size: 20px',
                label: 'complete date',

                setup: (self) => {
                    self.poll(1000, () => {
                        const time = DateTime.new_now_local();

                        self.label = time.format('%A, %B ') +
                            time.get_day_of_month() +
                            time.format(', %Y');
                    });
                },
            }),
        }),

    ],
});

const CalendarWidget = () => Box({
    class_name: 'cal-box',

    child: Calendar({
        show_day_names: true,
        show_heading: true,
        class_name: 'cal',
    }),
});

const TOP_MARGIN = 6;

export default () => PopupWindow({
    name: 'calendar',
    anchor: ['top'],
    margins: [TOP_MARGIN, 0, 0, 0],

    child: Box({
        class_name: 'date',
        vertical: true,

        children: [
            Time(),
            CalendarWidget(),
        ],
    }),
});

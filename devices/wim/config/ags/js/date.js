import { Box, Calendar, Label } from 'resource:///com/github/Aylur/ags/widget.js';

import GLib from 'gi://GLib';
const { DateTime } = GLib;

import PopupWindow from './misc/popup.js';


const Divider = () => Box({
    className: 'divider',
    vertical: true,
});

const Time = () => Box({
    className: 'timebox',
    vertical: true,
    children: [

        Box({
            className: 'time-container',
            hpack: 'center',
            vpack: 'center',
            children: [

                Label({
                    className: 'content',
                    label: 'hour',
                    setup: (self) => {
                        self.poll(1000, () => {
                            self.label = DateTime.new_now_local().format('%H');
                        });
                    },
                }),

                Divider(),

                Label({
                    className: 'content',
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
            className: 'date-container',
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
    className: 'cal-box',
    child: Calendar({
        showDayNames: true,
        showHeading: true,
        className: 'cal',
    }),
});

const TOP_MARGIN = 6;

export default () => PopupWindow({
    anchor: ['top'],
    margins: [TOP_MARGIN, 0, 0, 0],
    name: 'calendar',
    child: Box({
        className: 'date',
        vertical: true,
        children: [
            Time(),
            CalendarWidget(),
        ],
    }),
});

import { Widget } from '../imports.js';
const { Box, Label } = Widget;

import Gtk  from 'gi://Gtk';
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
            halign: 'center',
            valign: 'center',
            children: [

                Label({
                    className: 'content',
                    label: 'hour',
                    connections: [[1000, self => {
                        self.label = DateTime.new_now_local().format('%H');
                    }]],
                }),

                Divider(),

                Label({
                    className: 'content',
                    label: 'minute',
                    connections: [[1000, self => {
                        self.label = DateTime.new_now_local().format('%M');
                    }]],
                }),

            ],
        }),

        Box({
            className: 'date-container',
            halign: 'center',
            child: Label({
                style: 'font-size: 20px',
                label: 'complete date',
                connections: [[1000, self => {
                    var time = DateTime.new_now_local();
                    self.label = time.format('%A, %B ') +
                                 time.get_day_of_month() +
                                 time.format(', %Y');
                }]],
            }),
        }),

    ],
});

const CalendarWidget = () => Box({
    className: 'cal-box',
    child: Widget({
        type: Gtk.Calendar,
        showDayNames: true,
        showHeading: true,
        className: 'cal',
    }),
});

export default () => PopupWindow({
    anchor: ['top', 'right'],
    margin: [8, 182, 0, 0],
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

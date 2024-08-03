const { Box, Calendar, Label } = Widget;

const { new_now_local } = imports.gi.GLib.DateTime;


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
                            self.label = new_now_local().format('%H') || '';
                        });
                    },
                }),

                Divider(),

                Label({
                    class_name: 'content',
                    label: 'minute',
                    setup: (self) => {
                        self.poll(1000, () => {
                            self.label = new_now_local().format('%M') || '';
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
                        const time = new_now_local();

                        const dayNameMonth = time.format('%A, %B ');
                        const dayNum = time.get_day_of_month();
                        const date = time.format(', %Y');

                        if (dayNum && dayNameMonth && date) {
                            self.label = dayNameMonth + dayNum + date;
                        }
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

export default () => Box({
    class_name: 'date',
    vertical: true,

    children: [
        Time(),
        CalendarWidget(),
    ],
});

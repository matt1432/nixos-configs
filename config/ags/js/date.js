const { Box, Label, Window } = ags.Widget;
const { Gtk } = imports.gi;
const { DateTime } = imports.gi.GLib;

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
          connections: [[1000, label => {
            label.label = DateTime.new_now_local().format('%H');
          }]],
        }),

        Divider(),

        Label({
          className: 'content',
          label: 'minute',
          connections: [[1000, label => {
            label.label = DateTime.new_now_local().format('%M');
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
        connections: [[1000, label => {
          var time = DateTime.new_now_local();
          label.label = time.format("%A, %B ") + time.get_day_of_month()  + time.format(", %Y");
        }]],
      }),
    }),

  ],
});

const CalendarWidget = () => Box({
  className: 'cal-box',
  child: ags.Widget({
    type: Gtk.Calendar,
    showDayNames: true,
    showHeading: true,
    className: 'cal',
    connections: [/* */]
  }),
});

export const Calendar = Window({
  name: 'calendar',
  popup: true,
  layer: 'overlay',
  anchor: 'top right',
  margin: [ 8, 182, 0, 0],
  child: Box({
    className: 'date',
    vertical: true,
    children: [
      Time(),
      CalendarWidget(),
    ],
  }),
});

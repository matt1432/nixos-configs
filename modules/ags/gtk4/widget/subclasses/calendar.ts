import { register } from 'astal';
import { Gtk, type ConstructProps } from 'astal/gtk4';

import astalify, { type AstalifyProps } from './astalify';


type CalendarSignals = Record<`on${string}`, unknown[]> & {
    onDaySelected: []
    onNextMonth: []
    onNextYear: []
    onPrevMonth: []
    onPrevYear: []

};
export type CalendarProps = ConstructProps<
    CalendarClass,
    Gtk.Calendar.ConstructorProps & AstalifyProps,
    CalendarSignals
>;

@register({ GTypeName: 'Calendar' })
export class CalendarClass extends astalify(Gtk.Calendar) {
    constructor({ cssName = 'calendar', ...props }: CalendarProps = {}) {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        super({ cssName, ...props as any });
    }
}

export const Calendar = (props?: CalendarProps) => new CalendarClass(props);

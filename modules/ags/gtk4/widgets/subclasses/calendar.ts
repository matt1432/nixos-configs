import { register } from 'astal';
import { Gtk } from 'astal/gtk4';

import astalify, { type AstalifyProps, type ConstructProps } from '../astalify';

type CalendarSignals = Record<`on${string}`, unknown[]> & {
    onDaySelected: [];
    onNextMonth: [];
    onNextYear: [];
    onPrevMonth: [];
    onPrevYear: [];
};
export type CalendarProps = ConstructProps<
    CalendarClass,
    Gtk.Calendar.ConstructorProps & AstalifyProps,
    CalendarSignals
>;

@register({ GTypeName: 'Calendar' })
export class CalendarClass extends astalify(Gtk.Calendar) {
    constructor({ cssName = 'calendar', ...props }: CalendarProps = {}) {
        super({ cssName, ...props });
    }
}

export const Calendar = (props?: CalendarProps) => new CalendarClass(props);

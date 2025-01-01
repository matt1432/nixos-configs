/* eslint-disable @typescript-eslint/no-explicit-any */

import { register } from 'astal';
import { Gtk, type ConstructProps } from 'astal/gtk4';

import astalify from './astalify';


type CalendarSignals = Record<`on${string}`, unknown[]> & {
    onDaySelected: []
    onNextMonth: []
    onNextYear: []
    onPrevMonth: []
    onPrevYear: []

};
export type CalendarProps = ConstructProps<
    Calendar,
    Gtk.Calendar.ConstructorProps & { css: string },
    CalendarSignals
>;

@register({ GTypeName: 'Calendar' })
export class Calendar extends astalify(Gtk.Calendar) {
    constructor(props?: CalendarProps) { super(props as any); }
}

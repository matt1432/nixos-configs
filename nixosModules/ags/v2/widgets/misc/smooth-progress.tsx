import { bind } from 'astal';
import { Gtk, Widget } from 'astal/gtk3';
import { register, property } from 'astal/gobject';

type SmoothProgressProps = Widget.BoxProps & {
    transition_duration?: string
};


// PERF: this is kinda laggy
@register()
class SmoothProgress extends Widget.Box {
    @property(Number)
    declare fraction: number;

    @property(String)
    declare transition_duration: string;

    constructor({
        transition_duration = '1s',
        ...rest
    }: SmoothProgressProps = {}) {
        super(rest);
        this.transition_duration = transition_duration;

        const background = (
            <box
                className="background"
                hexpand
                vexpand
                halign={Gtk.Align.FILL}
                valign={Gtk.Align.FILL}
            />
        );

        const progress = (
            <box
                className="progress"
                vexpand
                valign={Gtk.Align.FILL}
                css={bind(this, 'fraction').as((fraction) => {
                    return `
                        transition: margin-right ${this.transition_duration} linear;
                        margin-right: ${
                            Math.abs(fraction - 1) * background.get_allocated_width()
                        }px;
                    `;
                })}
            />
        );

        this.add((
            <overlay overlay={progress}>
                {background}
            </overlay>
        ));
        this.show_all();
    }
}

export default SmoothProgress;

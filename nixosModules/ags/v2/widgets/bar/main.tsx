import { Astal, bind, Gtk, idle, Variable } from 'astal';

import FullscreenState from './fullscreen';


FullscreenState.subscribe((v) => {
    console.log(v);
});
const isVisible = Variable<boolean>(false);

export default () => {
    return (
        <window
            className="Bar"
            exclusivity={Astal.Exclusivity.EXCLUSIVE}
            anchor={
                Astal.WindowAnchor.TOP |
                Astal.WindowAnchor.LEFT |
                Astal.WindowAnchor.RIGHT
            }
            setup={() => idle(() => {
                isVisible.set(true);
            })}
        >
            <revealer
                revealChild={bind(isVisible)}
                transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}
                transitionDuration={500}
            >
                <label label="hi" />
            </revealer>
        </window>
    );
};

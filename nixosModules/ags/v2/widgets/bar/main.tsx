import { App, Astal, Gtk, idle, Variable } from 'astal';


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
            application={App}
            setup={() => idle(() => {
                isVisible.set(true);
            })}
        >
            <revealer
                revealChild={isVisible()}
                transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}
                transitionDuration={500}
            >
                <label label="hi" />
            </revealer>
        </window>
    );
};

import { Astal, Gdk } from 'astal/gtk3';


export default (
    monitor = Gdk.Display.get_default()?.get_monitor(0) as Gdk.Monitor,
    gradient = true,
) => {
    return (
        <window
            name="bg-layer"
            namespace="bg-layer"
            gdkmonitor={monitor}
            layer={Astal.Layer.BACKGROUND}
            exclusivity={Astal.Exclusivity.IGNORE}
            anchor={
                Astal.WindowAnchor.TOP |
                Astal.WindowAnchor.BOTTOM |
                Astal.WindowAnchor.LEFT |
                Astal.WindowAnchor.RIGHT
            }
            css={
                gradient ?
                    `
                        background-image: -gtk-gradient (linear,
                            left top, left bottom,
                            from(rgba(0, 0, 0, 0.5)),
                            to(rgba(0, 0, 0, 0)));
                    ` :
                    `
                        background-color: rgba(0, 0, 0, 0.4);
                    `
            }
        />
    );
};

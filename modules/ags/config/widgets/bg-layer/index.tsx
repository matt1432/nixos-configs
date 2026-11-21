import { Astal, Gdk } from 'ags/gtk4';

import { getMonitors } from '../../lib';

export default (monitor: Gdk.Monitor = getMonitors()[0], gradient = true) => {
    return (
        <window
            name="bg-layer"
            namespace="bg-layer"
            gdkmonitor={monitor}
            layer={Astal.Layer.BACKGROUND}
            exclusivity={Astal.Exclusivity.IGNORE}
            visible
            anchor={
                Astal.WindowAnchor.TOP |
                Astal.WindowAnchor.BOTTOM |
                Astal.WindowAnchor.LEFT |
                Astal.WindowAnchor.RIGHT
            }
            css={
                gradient
                    ? `
                        background-image: linear-gradient(
                            to bottom,
                            rgba(0, 0, 0, 0.5),
                            rgba(0, 0, 0, 0)
                        );
                    `
                    : `
                        background-color: rgba(0, 0, 0, 0.4);
                    `
            }
        />
    ) as Astal.Window;
};

import { Astal } from 'ags/gtk3';
import { execAsync } from 'ags/process';

import Gesture from './gesture';
import Keyboard from './keyboard';
import OskWindow from './osk-window';

export default () => {
    execAsync('ydotoold').catch(() => {});

    return Gesture(
        new OskWindow({
            name: 'osk',
            namespace: 'noanim-osk',
            layer: Astal.Layer.OVERLAY,
            anchor:
                Astal.WindowAnchor.BOTTOM |
                Astal.WindowAnchor.LEFT |
                Astal.WindowAnchor.RIGHT,
            child: Keyboard(),
        }),
    );
};

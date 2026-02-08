import { execAsync } from 'astal';
import { Astal } from 'astal/gtk3';

import Gesture from './gesture';
import Keyboard from './keyboard';
import OskWindow from './osk-window';

export default () => {
    execAsync('ydotoold').catch(() => {});

    return Gesture(
        (
            <OskWindow
                name="osk"
                namespace="noanim-osk"
                layer={Astal.Layer.OVERLAY}
                anchor={
                    Astal.WindowAnchor.BOTTOM |
                    Astal.WindowAnchor.LEFT |
                    Astal.WindowAnchor.RIGHT
                }
            >
                <Keyboard />
            </OskWindow>
        ) as OskWindow,
    );
};

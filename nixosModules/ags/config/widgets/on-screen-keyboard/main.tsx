import { execAsync } from 'astal';
import { Astal } from 'astal/gtk3';

import OskWindow from './osk-window';
import Gesture from './gesture';
import Keyboard from './keyboard';


export default () => {
    execAsync('ydotoold').catch(() => { /**/ });

    return Gesture((
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
    ) as OskWindow);
};

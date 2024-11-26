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

            exclusivity={Astal.Exclusivity.EXCLUSIVE}
            anchor={
                Astal.WindowAnchor.BOTTOM |
                Astal.WindowAnchor.LEFT |
                Astal.WindowAnchor.RIGHT
            }
            layer={Astal.Layer.OVERLAY}
        >
            <Keyboard />
        </OskWindow>
    ) as OskWindow);
};

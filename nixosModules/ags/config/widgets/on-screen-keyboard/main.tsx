import { execAsync, idle } from 'astal';
import { Astal } from 'astal/gtk3';

import Tablet from '../../services/tablet';

import OskWindow from './osk-window';
import Gesture from './gesture';
import Keyboard from './keyboard';


export default () => {
    // Start ydotool daemon
    execAsync('ydotoold').catch(print);

    const tablet = Tablet.get_default();

    const window = (
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
    ) as OskWindow;

    window.hook(tablet, 'notify::osk-state', (self, state) => {
        self.setVisible(state);
    });

    idle(() => {
        window.setVisible(false);
    });

    return Gesture(window);
};

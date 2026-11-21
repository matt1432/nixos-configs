import { createBinding } from 'ags';

import { getWindow } from '../../../lib';
import { pointer } from '../../../lib/widgets';
import Brightness from '../../../services/brightness';
import CircularProgress from '../../misc/circular-progress';

export default () => {
    const brightness = Brightness.get_default();

    return (
        <button
            cursor={pointer}
            class="bar-item brightness"
            onClicked={(self) => {
                const win = getWindow('win-brightness-slider')!;

                win.set_x_pos(self, 'right');

                win.set_visible(!win.get_visible());
            }}
        >
            <overlay>
                <CircularProgress
                    start_at={0.75}
                    end_at={0.75}
                    value={createBinding(brightness, 'screen')}
                    rounded
                />

                <image
                    $type="overlay"
                    canTarget={false}
                    iconName={createBinding(brightness, 'screenIcon')}
                />
            </overlay>
        </button>
    );
};

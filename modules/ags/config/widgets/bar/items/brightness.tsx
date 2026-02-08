import { bind } from 'astal';

import { getWindow } from '../../../lib';
import Brightness from '../../../services/brightness';

export default () => {
    const brightness = Brightness.get_default();

    return (
        <button
            cursor="pointer"
            className="bar-item brightness"
            onButtonReleaseEvent={(self) => {
                const win = getWindow('win-brightness-slider')!;

                win.set_x_pos(self.get_allocation(), 'right');

                win.set_visible(!win.get_visible());
            }}
        >
            <overlay passThrough>
                <circularprogress
                    startAt={0.75}
                    endAt={0.75}
                    value={bind(brightness, 'screen')}
                    rounded
                />

                <icon icon={bind(brightness, 'screenIcon')} />
            </overlay>
        </button>
    );
};

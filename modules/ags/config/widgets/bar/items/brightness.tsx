import { createBinding } from 'ags';

import { getWindow } from '../../../lib';
import Brightness from '../../../services/brightness';

export default () => {
    const brightness = Brightness.get_default();

    return (
        <cursor-button
            cursor="pointer"
            class="bar-item brightness"
            onButtonReleaseEvent={(self) => {
                const win = getWindow('win-brightness-slider')!;

                win.set_x_pos(self.get_allocation(), 'right');

                win.set_visible(!win.get_visible());
            }}
        >
            <overlay
                $={(self) => {
                    // passThrough doesn't work?
                    self.set_overlay_pass_through(self.get_children()[1], true);
                }}
            >
                <circularprogress
                    startAt={0.75}
                    endAt={0.75}
                    value={createBinding(brightness, 'screen')}
                    rounded
                />

                <icon
                    $type="overlay"
                    icon={createBinding(brightness, 'screenIcon')}
                />
            </overlay>
        </cursor-button>
    );
};

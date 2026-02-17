import { createBinding } from 'ags';
import AstalWp from 'gi://AstalWp';

import { getWindow } from '../../../lib';

export default () => {
    const speaker = AstalWp.get_default()?.get_audio()?.get_default_speaker();

    if (!speaker) {
        throw new Error('Could not find default audio devices.');
    }

    return (
        <cursor-button
            cursor="pointer"
            class="bar-item audio"
            onButtonReleaseEvent={(self) => {
                const win = getWindow('win-audio')!;

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
                    value={createBinding(speaker, 'volume')}
                    rounded
                    class={createBinding(speaker, 'mute').as((muted) =>
                        muted ? 'disabled' : '',
                    )}
                />

                <icon
                    $type="overlay"
                    icon={createBinding(speaker, 'volumeIcon')}
                />
            </overlay>
        </cursor-button>
    );
};

import { createBinding } from 'ags';
import AstalWp from 'gi://AstalWp';

import { getWindow } from '../../../lib';
import { pointer } from '../../../lib/widgets';
import CircularProgress from '../../misc/circular-progress';

export default () => {
    const speaker = AstalWp.get_default()?.get_audio()?.get_default_speaker();

    if (!speaker) {
        throw new Error('Could not find default audio devices.');
    }

    return (
        <button
            cursor={pointer}
            class="bar-item audio"
            onClicked={(self) => {
                const win = getWindow('win-audio')!;

                win.set_x_pos(self, 'right');

                win.set_visible(!win.get_visible());
            }}
        >
            <overlay>
                <CircularProgress
                    start_at={0.75}
                    end_at={0.75}
                    value={createBinding(speaker, 'volume')}
                    rounded
                    class={createBinding(speaker, 'mute').as((muted) =>
                        muted ? 'disabled' : '',
                    )}
                />

                <image
                    $type="overlay"
                    canTarget={false}
                    iconName={createBinding(speaker, 'volumeIcon')}
                />
            </overlay>
        </button>
    );
};

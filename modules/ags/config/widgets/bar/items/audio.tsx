import { bind } from 'astal';
import { App } from 'astal/gtk3';

import AstalWp from 'gi://AstalWp';

import PopupWindow from '../../misc/popup-window';


export default () => {
    const speaker = AstalWp.get_default()?.get_audio()?.get_default_speaker();

    if (!speaker) {
        throw new Error('Could not find default audio devices.');
    }

    return (
        <button
            cursor="pointer"
            className="bar-item audio"

            onButtonReleaseEvent={(self) => {
                const win = App.get_window('win-audio') as PopupWindow;

                win.set_x_pos(
                    self.get_allocation(),
                    'right',
                );

                win.set_visible(!win.get_visible());
            }}
        >
            <overlay passThrough>
                <circularprogress
                    startAt={0.75}
                    endAt={0.75}
                    value={bind(speaker, 'volume')}

                    rounded
                    className={bind(speaker, 'mute').as((muted) => muted ? 'disabled' : '')}
                />

                <icon icon={bind(speaker, 'volumeIcon')} />
            </overlay>
        </button>
    );
};

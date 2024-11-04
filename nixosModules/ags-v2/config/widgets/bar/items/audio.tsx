import { bind } from 'astal';

import AstalWp from 'gi://AstalWp';

export default () => {
    const speaker = AstalWp.get_default()?.audio.default_speaker;

    if (!speaker) {
        throw new Error('Could not find default audio devices.');
    }

    return (
        <box className="bar-item audio">
            <overlay>
                <circularprogress
                    startAt={0.75}
                    endAt={0.75}
                    value={bind(speaker, 'volume')}

                    rounded
                    className={bind(speaker, 'mute').as((muted) => muted ? 'disabled' : '')}
                />

                <icon icon={bind(speaker, 'volumeIcon')} />
            </overlay>
        </box>
    );
};

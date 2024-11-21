import { bind } from 'astal';

import Brightness from '../../../services/brightness';

export default () => {
    const brightness = Brightness.get_default();

    return (
        <box className="bar-item brightness">
            <overlay>
                <circularprogress
                    startAt={0.75}
                    endAt={0.75}
                    value={bind(brightness, 'screen')}
                    rounded
                />

                <icon icon={bind(brightness, 'screenIcon')} />
            </overlay>
        </box>
    );
};

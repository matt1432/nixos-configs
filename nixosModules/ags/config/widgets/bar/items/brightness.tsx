import { bind } from 'astal';

import Brightness from '../../../services/brightness';

export default () => {
    return (
        <box className="bar-item brightness">
            <overlay>
                <circularprogress
                    startAt={0.75}
                    endAt={0.75}
                    value={bind(Brightness, 'screen')}
                    rounded
                />

                <icon icon={bind(Brightness, 'screenIcon')} />
            </overlay>
        </box>
    );
};

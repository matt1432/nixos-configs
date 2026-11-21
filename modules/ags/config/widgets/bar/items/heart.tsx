import { createState } from 'ags';

import { pointer } from '../../../lib/widgets';
import Persist from '../../misc/persist';

const [HeartState, setHeartState] = createState('');

Persist({
    name: 'heart',
    variableGetter: HeartState,
    variableSetter: setHeartState,
    condition: '',
    whenFalse: '󰣐',
});

export default () => (
    <button
        class="bar-item heart-toggle"
        cursor={pointer}
        onClicked={() => {
            setHeartState(HeartState() === '' ? '󰣐' : '');
        }}
    >
        <label label={HeartState} css="font-size: 28px;" />
    </button>
);

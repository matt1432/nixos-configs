import { createState } from 'ags';

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
    <cursor-button
        class="bar-item heart-toggle"
        cursor="pointer"
        onButtonReleaseEvent={() => {
            setHeartState(HeartState() === '' ? '󰣐' : '');
        }}
    >
        <label
            label={HeartState}
            css="margin-left: -6px; margin-right: 4px; font-size: 28px;"
        />
    </cursor-button>
);

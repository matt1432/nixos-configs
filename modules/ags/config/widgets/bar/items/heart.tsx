import { Variable } from 'astal';

import Persist from '../../misc/persist';

const HeartState = Variable('');

Persist({
    name: 'heart',
    variable: HeartState,
    condition: '',
    whenFalse: '󰣐',
});


export default () => (
    <button
        className="bar-item heart-toggle"
        cursor="pointer"

        onButtonReleaseEvent={() => {
            HeartState.set(HeartState.get() === '' ? '󰣐' : '');
        }}
    >
        <label
            label={HeartState()}
            css="margin-left: -6px; margin-right: 4px; font-size: 28px;"
        />
    </button>
);

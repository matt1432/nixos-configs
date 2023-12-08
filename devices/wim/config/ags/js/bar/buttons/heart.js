import { Label } from 'resource:///com/github/Aylur/ags/widget.js';

import Variable from 'resource:///com/github/Aylur/ags/variable.js';

import EventBox from '../../misc/cursorbox.js';
import Persist from '../../misc/persist.js';

const HeartState = Variable();

Persist({
    name: 'heart',
    gobject: HeartState,
    prop: 'value',
    condition: '',
    whenFalse: '󰣐',
});


export default () => EventBox({
    onPrimaryClickRelease: () => {
        HeartState.value = HeartState.value === '' ? '󰣐' : '';
    },

    child: Label({
        className: 'heart-toggle',
        binds: [['label', HeartState, 'value']],
    }),
});

import { Box, Label } from 'resource:///com/github/Aylur/ags/widget.js';

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


export default () => {
    return EventBox({
        onPrimaryClickRelease: () => {
            HeartState.value = HeartState.value === '' ? '󰣐' : '';
        },

        child: Box({
            className: 'heart-toggle',

            child: Label({
                binds: [['label', HeartState, 'value']],
            }),
        }),
    });
};

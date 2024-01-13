import { Label } from 'resource:///com/github/Aylur/ags/widget.js';

import Variable from 'resource:///com/github/Aylur/ags/variable.js';

import CursorBox from '../../misc/cursorbox.js';
import Persist from '../../misc/persist.js';

const HeartState = Variable('');

Persist({
    name: 'heart',
    gobject: HeartState,
    prop: 'value',
    condition: '',
    whenFalse: '󰣐',
});


export default () => CursorBox({
    on_primary_click_release: () => {
        HeartState.value = HeartState.value === '' ? '󰣐' : '';
    },

    child: Label({
        class_name: 'heart-toggle',
        label: HeartState.bind(),
    }),
});

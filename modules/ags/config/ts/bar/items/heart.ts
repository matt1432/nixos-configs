const { Label } = Widget;

import CursorBox from '../../misc/cursorbox.ts';
import Persist from '../../misc/persist.ts';

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
        HeartState.setValue(HeartState.value === '' ? '󰣐' : '');
    },

    child: Label({
        class_name: 'heart-toggle',
        label: HeartState.bind(),
    }),
});

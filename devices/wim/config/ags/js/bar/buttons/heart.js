import { Box, Label } from 'resource:///com/github/Aylur/ags/widget.js';
import { execAsync, readFileAsync } from 'resource:///com/github/Aylur/ags/utils.js';

import Variable from 'resource:///com/github/Aylur/ags/variable.js';

const { get_home_dir } = imports.gi.GLib;

import EventBox from '../../misc/cursorbox.js';

const HeartState = Variable('');
const heartFile = `${get_home_dir()}/.cache/ags/.heart`;

const stateCmd = () => ['bash', '-c',
    `echo ${HeartState.value === ''} > ${heartFile}`];
const monitorState = () => {
    HeartState.connect('changed', () => {
        execAsync(stateCmd()).catch(print);
    });
};

// On launch
readFileAsync(heartFile).then((content) => {
    HeartState.value = JSON.parse(content) ? '' : '󰣐';
    monitorState();
}).catch(() => {
    execAsync(stateCmd()).then(() => {
        monitorState();
    }).catch(print);
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

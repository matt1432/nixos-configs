import { Window } from 'resource:///com/github/Aylur/ags/widget.js';

import RoundedCorner from './screen-corners.js';


const TopLeft = () => Window({
    name: 'cornertl',
    layer: 'overlay',
    exclusivity: 'ignore',
    anchor: ['top', 'left'],
    visible: true,
    child: RoundedCorner('topleft'),
});

const TopRight = () => Window({
    name: 'cornertr',
    layer: 'overlay',
    exclusivity: 'ignore',
    anchor: ['top', 'right'],
    visible: true,
    child: RoundedCorner('topright'),
});

const BottomLeft = () => Window({
    name: 'cornerbl',
    layer: 'overlay',
    exclusivity: 'ignore',
    anchor: ['bottom', 'left'],
    visible: true,
    child: RoundedCorner('bottomleft'),
});

const BottomRight = () => Window({
    name: 'cornerbr',
    layer: 'overlay',
    exclusivity: 'ignore',
    anchor: ['bottom', 'right'],
    visible: true,
    child: RoundedCorner('bottomright'),
});


export default () => [
    TopLeft(),
    TopRight(),
    BottomLeft(),
    BottomRight(),
];

const { Window } = Widget;

import RoundedCorner from './screen-corners.ts';


const TopLeft = () => Window({
    name: 'cornertl',
    layer: 'overlay',
    exclusivity: 'ignore',
    anchor: ['top', 'left'],
    visible: true,
    click_through: true,
    child: RoundedCorner('topleft'),
});

const TopRight = () => Window({
    name: 'cornertr',
    layer: 'overlay',
    exclusivity: 'ignore',
    anchor: ['top', 'right'],
    visible: true,
    click_through: true,
    child: RoundedCorner('topright'),
});

const BottomLeft = () => Window({
    name: 'cornerbl',
    layer: 'overlay',
    exclusivity: 'ignore',
    anchor: ['bottom', 'left'],
    visible: true,
    click_through: true,
    child: RoundedCorner('bottomleft'),
});

const BottomRight = () => Window({
    name: 'cornerbr',
    layer: 'overlay',
    exclusivity: 'ignore',
    anchor: ['bottom', 'right'],
    visible: true,
    click_through: true,
    child: RoundedCorner('bottomright'),
});


export default () => [
    TopLeft(),
    TopRight(),
    BottomLeft(),
    BottomRight(),
];

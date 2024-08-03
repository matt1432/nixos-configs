const { Window } = Widget;


export default () => Window({
    name: 'bg-gradient',
    layer: 'background',
    exclusivity: 'ignore',
    anchor: ['top', 'bottom', 'left', 'right'],
    css: `
        background-image: -gtk-gradient (linear,
                          left top, left bottom,
                          from(rgba(0, 0, 0, 0.5)),
                          to(rgba(0, 0, 0, 0)));
    `,
});

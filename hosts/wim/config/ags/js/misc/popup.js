import { App, Widget } from '../../imports.js';
const { Revealer, Box, Window } = Widget;


export default ({
    name,
    child,
    closeOnUnfocus = 'released',
    transition = 'slide_down',
    onOpen = () => {},
    ...props
}) => {
    const window = Window({
        name,
        popup: true,
        visible: false,
        layer: 'overlay',
        ...props,

        child: Box({
            style: `min-height:1px;
                    min-width:1px;
                    padding: 1px;`,
            child: Revealer({
                transition,
                transitionDuration: 500,
                connections: [[App, (rev, currentName, visible) => {
                    if (currentName === name) {
                        rev.reveal_child = visible;
                        onOpen(child);
                    }
                }]],
                child: child,
            }),
        }),
    });
    window.getChild = () => child;
    window.closeOnUnfocus = closeOnUnfocus;
    return window;
};

import App from 'resource:///com/github/Aylur/ags/app.js';
import { Revealer, Box, Window } from 'resource:///com/github/Aylur/ags/widget.js';


export default ({
    // Revealer props
    transition = 'slide_down',
    transitionDuration = 500,
    // Optional: execute a function whenever the window pops up
    onOpen = () => {},

    // Window props
    name,
    child,
    closeOnUnfocus = 'released',
    visible = false,
    layer = 'overlay',
    ...props
}) => {
    const window = Window({
        name,
        layer,
        popup: true,
        visible: false,
        ...props,

        // Add way to make window open on startup
        setup: () => {
            const id = App.connect('config-parsed', () => {
                if (visible)
                    App.openWindow(name);
                App.disconnect(id);
            });
        },

        // Wrapping the revealer inside a box is needed
        // to allocate some space for it even when not revealed
        child: Box({
            style: `min-height:1px;
                    min-width:1px;
                    padding: 1px;`,
            child: Revealer({
                transition,
                transitionDuration,
                connections: [[App, (rev, currentName, visible) => {
                    if (currentName === name) {
                        rev.revealChild = visible;
                        onOpen(child);
                    }
                }]],
                child: child,
            }),
        }),
    });

    // Make getting the original child passed in
    // this function easier when making more code
    // for the widget
    window.getChild = () => child;

    // This is for my custom pointers.js
    window.closeOnUnfocus = closeOnUnfocus;

    return window;
};

import App from 'resource:///com/github/Aylur/ags/app.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

import { Revealer, Box, Window } from 'resource:///com/github/Aylur/ags/widget.js';
import { timeout } from 'resource:///com/github/Aylur/ags/utils.js';


export default ({
    // Revealer props
    transition = 'slide_down',
    transitionDuration = 500,

    // Optional: execute a function whenever
    // the window pops up or goes away
    onOpen = () => { /**/ },
    onClose = () => { /**/ },

    // Window props
    name,
    child,
    blur = false,
    closeOnUnfocus = 'released',
    visible = false,
    layer = 'overlay',
    ...props
}) => {
    const window = Window({
        name,
        layer,
        visible: false,
        ...props,

        setup: () => {
            // Add way to make window open on startup
            const id = App.connect('config-parsed', () => {
                if (visible) {
                    App.openWindow(name);
                }
                App.disconnect(id);
            });

            if (blur) {
                Hyprland.sendMessage('[[BATCH]] ' +
                    `keyword layerrule ignorealpha[0.97],${name}; ` +
                    `keyword layerrule blur,${name}`);
            }
        },

        // Wrapping the revealer inside a box is needed
        // to allocate some space for it even when not revealed
        child: Box({
            css: `
                min-height:1px;
                min-width:1px;
                padding: 1px;
            `,
            child: Revealer({
                transition,
                transitionDuration,

                setup: (self) => {
                    self.hook(App, (_, currentName, isOpen) => {
                        if (currentName === name) {
                            self.revealChild = isOpen;

                            if (isOpen) {
                                onOpen(window);
                            }
                            else {
                                timeout(transitionDuration, () => {
                                    onClose(window);
                                });
                            }
                        }
                    });
                },

                child: child || Box(),
            }),
        }),
    });

    window.setXPos = (
        alloc,
        side = 'right',
    ) => {
        const width = window.get_display()
            .get_monitor_at_point(alloc.x, alloc.y)
            .get_geometry().width;

        window.margins = [
            window.margins[0],

            side === 'right' ?
                (width - alloc.x - alloc.width) :
                window.margins[1],

            window.margins[2],

            side === 'right' ?
                window.margins[3] :
                (alloc.x - alloc.width),
        ];
    };

    // Make getting the original child passed in this
    // function easier when making more code for the widget
    window.getChild = () => window.child.children[0].child;
    window.setChild = (newChild) => {
        window.child.children[0].child = newChild;
        window.child.children[0].show_all();
    };

    // This is for my custom pointers.js
    window.closeOnUnfocus = closeOnUnfocus;

    return window;
};

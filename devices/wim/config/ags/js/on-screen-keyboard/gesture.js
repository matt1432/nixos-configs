import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Gtk from 'gi://Gtk';


export default window => {
    const gesture = Gtk.GestureDrag.new(window);

    gesture.signals = [];
    window.killGestureSigs = () => {
        gesture.signals.forEach(id => gesture.disconnect(id));
        gesture.signals = [];
    };

    window.setSlideUp = () => {
        console.log(window.get_allocated_height());

        window.killGestureSigs();

        // Begin drag
        gesture.signals.push(
            gesture.connect('drag-begin', () => {
                Hyprland.sendMessage('j/cursorpos').then(out => {
                    gesture.startY = JSON.parse(out).y;
                });
            }),
        );

        // Update drag
        gesture.signals.push(
            gesture.connect('drag-update', () => {
                Hyprland.sendMessage('j/cursorpos').then(out => {
                    const currentY = JSON.parse(out).y;
                    const offset = gesture.startY - currentY;

                    if (offset < 0)
                        return;

                    window.child.setCss(`
                        margin-bottom: ${offset}px;
                    `);
                });
            }),
        );

        // End drag
        gesture.signals.push(
            gesture.connect('drag-end', () => {
                window.child.setCss(`
                    transition: margin-bottom 0.5s ease-in-out;
                    margin-bottom: 0px;
                `);
            }),
        );
    };

    window.setSlideDown = () => {
        window.killGestureSigs();

        // Begin drag
        gesture.signals.push(
            gesture.connect('drag-begin', () => {
                Hyprland.sendMessage('j/cursorpos').then(out => {
                    gesture.startY = JSON.parse(out).y;
                });
            }),
        );

        // Update drag
        gesture.signals.push(
            gesture.connect('drag-update', () => {
                Hyprland.sendMessage('j/cursorpos').then(out => {
                    const currentY = JSON.parse(out).y;
                    const offset = gesture.startY - currentY;

                    if (offset > 0)
                        return;

                    window.child.setCss(`
                        margin-bottom: ${offset}px;
                    `);
                });
            }),
        );

        // End drag
        gesture.signals.push(
            gesture.connect('drag-end', () => {
                window.child.setCss(`
                    transition: margin-bottom 0.5s ease-in-out;
                    margin-bottom: 0px;
                `);
            }),
        );
    };

    window.setSlideDown();

    return window;
};

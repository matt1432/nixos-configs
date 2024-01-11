import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

import { Button, EventBox } from 'resource:///com/github/Aylur/ags/widget.js';

import Cairo from 'cairo';
const { Gtk, Gdk } = imports.gi;

import { updateClients } from './clients.js';

const TARGET = [Gtk.TargetEntry.new('text/plain', Gtk.TargetFlags.SAME_APP, 0)];
const display = Gdk.Display.get_default();

/**
 * @typedef {import('types/widgets/button').default} Button
 * @typedef {import('types/widgets/button').ButtonProps} ButtonProps
 * @typedef {import('types/widgets/eventbox').EventBoxProps=} EventBoxProps
 * @typedef {import('types/widgets/box').default} Box
 */


/** @param {Button} widget */
const createSurfaceFromWidget = (widget) => {
    const alloc = widget.get_allocation();
    const surface = new Cairo.ImageSurface(
        Cairo.Format.ARGB32,
        alloc.width,
        alloc.height,
    );
    const cr = new Cairo.Context(surface);

    cr.setSourceRGBA(255, 255, 255, 0);
    cr.rectangle(0, 0, alloc.width, alloc.height);
    cr.fill();
    widget.draw(cr);

    return surface;
};

let hidden = 0;

/** @params {EventBoxProps} props */
export const WorkspaceDrop = ({ ...props }) => EventBox({
    ...props,
    setup: (self) => {
        self.drag_dest_set(Gtk.DestDefaults.ALL, TARGET, Gdk.DragAction.COPY);

        self.on('drag-data-received', (_, _c, _x, _y, data) => {
            // @ts-expect-error
            let id = self.get_parent()?.attribute.id;

            if (id < -1) {
                // @ts-expect-error
                id = self.get_parent()?.attribute.name;
            }

            else if (id === -1) {
                id = `special:${++hidden}`;
            }

            else if (id === 1000) {
                id = 'empty';
            }

            Hyprland.sendMessage('dispatch ' +
                `movetoworkspacesilent ${id},address:${data.get_text()}`)
                .catch(print);
        });
    },
});

/**
 * @param {ButtonProps & {
 *      address: string
 *      mainBox: Box
 * }} o
 */
export const WindowButton = ({
    address,
    mainBox,
    ...props
}) => Button({
    ...props,

    setup: (self) => {
        self.drag_source_set(
            Gdk.ModifierType.BUTTON1_MASK,
            TARGET,
            Gdk.DragAction.COPY,
        );

        self
            .on('drag-data-get', (_w, _c, data) => {
                data.set_text(address, address.length);
            })

            .on('drag-begin', (_, context) => {
                Gtk.drag_set_icon_surface(
                    context,
                    createSurfaceFromWidget(self),
                );
                // @ts-expect-error
                self.get_parent()?.set_reveal_child(false);
            })

            .on('drag-end', () => {
                self.get_parent()?.destroy();

                updateClients(mainBox);
            })

            // OnHover
            .on('enter-notify-event', () => {
                self.window.set_cursor(Gdk.Cursor.new_from_name(
                    display,
                    'pointer',
                ));
                self.toggleClassName('hover', true);
            })

            // OnHoverLost
            .on('leave-notify-event', () => {
                self.window.set_cursor(null);
                self.toggleClassName('hover', false);
            });
    },
});

const Hyprland = await Service.import('hyprland');

const { Button, EventBox } = Widget;

import Cairo from 'cairo';
const { Gtk, Gdk } = imports.gi;

import { updateClients } from './clients.ts';

const TARGET = [Gtk.TargetEntry.new('text/plain', Gtk.TargetFlags.SAME_APP, 0)];
const display = Gdk.Display.get_default();

// Types
import AgsBox from 'types/widgets/box.ts';
import AgsButton from 'types/widgets/button.ts';
import AgsRevealer from 'types/widgets/revealer.ts';
import { ButtonProps } from 'types/widgets/button.ts';
import { EventBoxProps } from 'types/widgets/eventbox.ts';
type WindowButtonType = ButtonProps & {
    address: string
    mainBox: AgsBox
};


const createSurfaceFromWidget = (widget: AgsButton) => {
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

export const WorkspaceDrop = ({ ...props }: EventBoxProps) => EventBox({
    ...props,
    setup: (self) => {
        self.drag_dest_set(Gtk.DestDefaults.ALL, TARGET, Gdk.DragAction.COPY);

        self.on('drag-data-received', (_, _c, _x, _y, data) => {
            let id = (self.get_parent() as AgsRevealer)?.attribute.id;

            if (id < -1) {
                id = (self.get_parent() as AgsRevealer)?.attribute.name;
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

export const WindowButton = ({
    address,
    mainBox,
    ...props
}: WindowButtonType) => Button({
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
                (self.get_parent() as AgsRevealer)?.set_reveal_child(false);
            })

            .on('drag-end', () => {
                self.get_parent()?.destroy();

                updateClients(mainBox);
            })

            // OnHover
            .on('enter-notify-event', () => {
                if (!display) {
                    return;
                }
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

import { createBinding, createRoot } from 'ags';
import { Gtk } from 'ags/gtk4';
import app from 'ags/gtk4/app';
import { idle } from 'ags/time';
import AstalTray from 'gi://AstalTray';

import { pointer } from '../../../lib/widgets';

const SKIP_ITEMS = ['.spotify-wrapped'];

const TrayItem = (item: AstalTray.TrayItem) => {
    if (item.iconThemePath) {
        app.add_icons(item.get_icon_theme_path());
    }

    return (
        <revealer
            transitionType={Gtk.RevealerTransitionType.SLIDE_RIGHT}
            revealChild={false}
        >
            <menubutton
                class="tray-item"
                // Keeps the button square so its hover background stays a circle
                valign={Gtk.Align.CENTER}
                cursor={pointer}
                menuModel={createBinding(item, 'menuModel')}
                tooltipMarkup={createBinding(item, 'tooltipMarkup')}
                $={(self) => {
                    self.insert_action_group('dbusmenu', item.actionGroup);

                    item.connect('notify::action-group', () => {
                        self.insert_action_group('dbusmenu', item.actionGroup);
                    });

                    self.set_child(
                        (
                            <image gicon={createBinding(item, 'gicon')} />
                        ) as Gtk.Image,
                    );
                }}
            />
        </revealer>
    ) as Gtk.Revealer;
};

export default () => {
    const tray = AstalTray.get_default();

    const itemMap = new Map<
        string,
        { widget: Gtk.Revealer; dispose: () => void }
    >();

    return (
        <box
            class="bar-item system-tray"
            visible={createBinding(tray, 'items').as(
                (items) => items.length !== 0,
            )}
            $={(self) => {
                const addItem = (id: string) => {
                    if (
                        itemMap.has(id) ||
                        SKIP_ITEMS.includes(tray.get_item(id).get_title())
                    ) {
                        return;
                    }

                    let dispose = () => {};
                    const widget = createRoot((d) => {
                        dispose = d;

                        return TrayItem(tray.get_item(id));
                    });

                    itemMap.set(id, { widget, dispose });

                    self.append(widget);

                    idle(() => {
                        widget.set_reveal_child(true);
                    });
                };

                tray.get_items().forEach((item) => {
                    addItem(item.itemId);
                });

                tray.connect('item-added', (_, id: string) => {
                    addItem(id);
                });

                tray.connect('item-removed', (_, id: string) => {
                    const entry = itemMap.get(id);

                    if (!entry) {
                        return;
                    }

                    itemMap.delete(id);
                    entry.widget.set_reveal_child(false);

                    setTimeout(() => {
                        self.remove(entry.widget);
                        entry.dispose();
                    }, 1000);
                });
            }}
        />
    );
};

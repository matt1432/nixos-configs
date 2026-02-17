import { createBinding } from 'ags';
import { Gtk } from 'ags/gtk3';
import app from 'ags/gtk3/app';
import { idle } from 'ags/time';
import AstalTray from 'gi://AstalTray';

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
            <cursor-menubutton
                class="tray-item"
                cursor="pointer"
                usePopover={false}
                $={(self) => {
                    self.menuModel = item.menuModel;
                    self.insert_action_group('dbusmenu', item.actionGroup);

                    item.connect('notify::action-group', () => {
                        self.insert_action_group('dbusmenu', item.actionGroup);
                    });

                    item.connect('notify::tooltip-markup', () => {
                        self.set_tooltip_markup(item.tooltipMarkup);
                    });
                }}
            >
                <icon
                    $={(self) => {
                        self.gicon = item.gicon;
                        item.connect('notify::gicon', () => {
                            self.gicon = item.gicon;
                        });
                    }}
                />
            </cursor-menubutton>
        </revealer>
    ) as Gtk.Revealer;
};

export default () => {
    const tray = AstalTray.get_default();

    const itemMap = new Map<string, Gtk.Revealer>();

    return (
        <box
            class="bar-item system-tray"
            visible={createBinding(tray, 'items').as(
                (items) => items.length !== 0,
            )}
            $={(self) => {
                tray.connect('item-added', (_, item: string) => {
                    if (
                        itemMap.has(item) ||
                        SKIP_ITEMS.includes(tray.get_item(item).get_title())
                    ) {
                        return;
                    }

                    const widget = TrayItem(tray.get_item(item));

                    itemMap.set(item, widget);

                    self.add(widget);

                    idle(() => {
                        widget.set_reveal_child(true);
                    });
                });

                tray.connect('item-removed', (_, item: string) => {
                    if (!itemMap.has(item)) {
                        return;
                    }

                    const widget = itemMap.get(item);

                    widget?.set_reveal_child(false);

                    setTimeout(() => {
                        widget?.destroy();
                    }, 1000);
                });
            }}
        />
    );
};

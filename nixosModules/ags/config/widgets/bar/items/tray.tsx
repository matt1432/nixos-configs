import { App, Gdk, Gtk, Widget } from 'astal/gtk3';
import { bind, idle } from 'astal';

import AstalTray from 'gi://AstalTray';


const SKIP_ITEMS = ['.spotify-wrapped'];

const TrayItem = (item: AstalTray.TrayItem) => {
    if (item.iconThemePath) {
        App.add_icons(item.iconThemePath);
    }

    const menu = item.create_menu();

    return (
        <revealer
            transitionType={Gtk.RevealerTransitionType.SLIDE_RIGHT}
            revealChild={false}
        >
            <button
                className="tray-item"
                cursor="pointer"
                tooltipMarkup={bind(item, 'tooltipMarkup')}
                onDestroy={() => menu?.destroy()}
                onClickRelease={(self) => {
                    menu?.popup_at_widget(self, Gdk.Gravity.SOUTH, Gdk.Gravity.NORTH, null);
                }}
            >
                <icon gIcon={bind(item, 'gicon')} />
            </button>
        </revealer>
    );
};

export default () => {
    const tray = AstalTray.get_default();

    const itemMap = new Map<string, Widget.Revealer>();

    return (
        <box
            className="bar-item system-tray"
            visible={bind(tray, 'items').as((items) => items.length !== 0)}
            setup={(self) => {
                self
                    .hook(tray, 'item-added', (_, item: string) => {
                        if (itemMap.has(item) || SKIP_ITEMS.includes(tray.get_item(item).title)) {
                            return;
                        }

                        const widget = TrayItem(tray.get_item(item)) as Widget.Revealer;

                        itemMap.set(item, widget);

                        self.add(widget);

                        idle(() => {
                            widget.set_reveal_child(true);
                        });
                    })

                    .hook(tray, 'item-removed', (_, item: string) => {
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

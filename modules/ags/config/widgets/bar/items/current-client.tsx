import { Gtk } from 'ags/gtk3';
import AstalApps from 'gi://AstalApps';
import AstalHyprland from 'gi://AstalHyprland';
import { createState } from 'gnim';

import Separator from '../../misc/separator';

export default () => {
    const applications = AstalApps.Apps.new();
    const hyprland = AstalHyprland.get_default();

    const [visibleIcon, setVisibleIcon] = createState(false);
    const [focusedIcon, setFocusedIcon] = createState('');
    const [focusedTitle, setFocusedTitle] = createState('');

    let lastFocusedAddress: string | null;

    const updateVars = (
        client: AstalHyprland.Client | null = hyprland.get_focused_client(),
    ) => {
        lastFocusedAddress = client ? client.get_address() : null;

        const app = applications.fuzzy_query(client?.get_class() ?? '')[0];

        const icon = app?.get_icon_name();

        if (icon) {
            setVisibleIcon(true);
            setFocusedIcon(icon);
        }
        else {
            setVisibleIcon(false);
        }

        setFocusedTitle(client?.get_title() ?? '');
        const id = client?.connect('notify::title', (c) => {
            if (c.get_address() !== lastFocusedAddress && id) {
                c.disconnect(id);
            }
            else {
                setFocusedTitle(c.get_title());
            }
        });
    };

    updateVars();
    hyprland.connect('notify::focused-client', () => updateVars());

    return (
        <revealer
            transitionType={Gtk.RevealerTransitionType.SLIDE_RIGHT}
            revealChild={focusedTitle.as((title) => title !== '')}
        >
            <box>
                <Separator size={8} />

                <box class="bar-item current-window">
                    <revealer
                        transitionType={Gtk.RevealerTransitionType.SLIDE_RIGHT}
                        revealChild={visibleIcon}
                    >
                        <box>
                            <icon css="font-size: 32px;" icon={focusedIcon} />

                            <Separator size={8} />
                        </box>
                    </revealer>

                    <label label={focusedTitle} truncate maxWidthChars={35} />
                </box>
            </box>
        </revealer>
    );
};

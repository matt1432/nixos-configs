import { createState } from 'ags';
import { Gtk } from 'ags/gtk3';
import AstalApps from 'gi://AstalApps';
import AstalHyprland from 'gi://AstalHyprland';

import Separator from '../../misc/separator';

export default () => {
    const applications = AstalApps.Apps.new();
    const hyprland = AstalHyprland.get_default();

    const [visibleIcon, setVisibleIcon] = createState(false);
    const [focusedIcon, setFocusedIcon] = createState('');

    const updateVars = (
        client: AstalHyprland.Client | null = hyprland.get_focused_client(),
    ) => {
        const app = applications.fuzzy_query(client?.get_class() ?? '')[0];

        const icon = app?.get_icon_name();

        if (icon) {
            setVisibleIcon(true);
            setFocusedIcon(icon);
        }
        else {
            setVisibleIcon(false);
        }
    };

    updateVars();
    hyprland.connect('notify::focused-client', () => updateVars());

    return (
        <revealer
            transitionType={Gtk.RevealerTransitionType.SLIDE_RIGHT}
            revealChild={visibleIcon}
        >
            <box>
                <box class="bar-item current-window">
                    <icon css="font-size: 32px;" icon={focusedIcon} />
                </box>

                <Separator size={8} />
            </box>
        </revealer>
    );
};

import { bind, execAsync, Variable } from 'astal';
import { App, Gtk, Widget } from 'astal/gtk3';

import AstalApps from 'gi://AstalApps';
const Applications = AstalApps.Apps.new();

import AstalHyprland from 'gi://AstalHyprland';
const Hyprland = AstalHyprland.get_default();

import PopupWindow from '../misc/popup-window';
import Separator from '../misc/separator';

import { get_app_icon, hyprMessage } from '../../lib';


const ICON_SEP = 6;
const takeScreenshot = (selector: string, delay = 1000): void => {
    App.get_window('win-screenshot')?.set_visible(false);

    setTimeout(() => {
        execAsync([
            'bash',
            '-c',
            `grim ${selector} - | satty -f - || true`,
        ]).catch(console.error);
    }, delay);
};

export default () => {
    const windowList = <box vertical /> as Widget.Box;

    const updateWindows = async() => {
        if (!App.get_window('win-screenshot')?.visible) {
            return;
        }

        windowList.children = (JSON.parse(await hyprMessage('j/clients')) as AstalHyprland.Client[])
            .filter((client) => client.workspace.id === Hyprland.get_focused_workspace().get_id())
            .map((client) => (
                <button
                    className="item-btn"
                    cursor="pointer"

                    onButtonReleaseEvent={() => {
                        takeScreenshot(`-w ${client.address}`);
                    }}
                >
                    <box halign={Gtk.Align.CENTER}>
                        <icon icon={get_app_icon(Applications.fuzzy_query(client.class)[0])} />

                        <Separator size={ICON_SEP} />

                        <label
                            label={client.title}
                            truncate
                            max_width_chars={50}
                        />
                    </box>
                </button>
            ));
    };

    Hyprland.connect('notify::clients', updateWindows);
    Hyprland.connect('notify::focused-workspace', updateWindows);

    const Shown = Variable<string>('monitors');

    const stack = (
        <stack
            shown={bind(Shown)}
            transitionType={Gtk.StackTransitionType.SLIDE_LEFT_RIGHT}
        >
            <scrollable name="monitors">
                <box vertical>
                    {bind(Hyprland, 'monitors').as((monitors) => monitors.map((monitor) => (
                        <button
                            className="item-btn"
                            cursor="pointer"

                            onButtonReleaseEvent={() => {
                                takeScreenshot(`-o ${monitor.name}`);
                            }}
                        >
                            <label
                                label={`${monitor.name}: ${monitor.description}`}
                                truncate
                                maxWidthChars={50}
                            />
                        </button>
                    )))}
                </box>
            </scrollable>

            <scrollable name="windows">
                {windowList}
            </scrollable>
        </stack>
    ) as Widget.Stack;

    const StackButton = ({ label = '', iconName = '' }) => (
        <button
            cursor="pointer"
            className={bind(Shown).as((shown) =>
                `header-btn${shown === label ? ' active' : ''}`)}

            onButtonReleaseEvent={() => {
                Shown.set(label);
            }}
        >
            <box halign={Gtk.Align.CENTER}>
                <icon icon={iconName} />

                <Separator size={ICON_SEP} />

                {label}
            </box>
        </button>
    ) as Widget.Button;

    const regionButton = (
        <button
            cursor="pointer"
            className="header-btn"

            onButtonReleaseEvent={() => {
                takeScreenshot('-g "$(slurp)"', 0);
            }}
        >
            <box halign={Gtk.Align.CENTER}>
                <icon icon="tool-pencil-symbolic" />

                <Separator size={ICON_SEP} />

                region
            </box>
        </button>
    ) as Widget.Button;

    return (
        <PopupWindow
            name="screenshot"
            on_open={() => {
                updateWindows();
            }}
        >
            <box
                className="screenshot widget"
                vertical
            >
                <box
                    className="header"
                    homogeneous
                >
                    <StackButton label="monitors" iconName="display-symbolic" />
                    <StackButton label="windows" iconName="window-symbolic" />
                    {regionButton}
                </box>

                {stack}
            </box>
        </PopupWindow>
    );
};

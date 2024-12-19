import { bind, execAsync, Variable } from 'astal';
import { App, Gtk, Widget } from 'astal/gtk3';

import AstalApps from 'gi://AstalApps';
import AstalHyprland from 'gi://AstalHyprland';

import PopupWindow from '../misc/popup-window';
import Separator from '../misc/separator';

import { hyprMessage } from '../../lib';


const ICON_SEP = 6;
const takeScreenshot = (selector: string[], delay = 1000): void => {
    App.get_window('win-screenshot')?.set_visible(false);

    setTimeout(() => {
        execAsync([
            `${SRC}/widgets/screenshot/capture.sh`,
        ].concat(selector)).catch(console.error);
    }, delay);
};

export default () => {
    const hyprland = AstalHyprland.get_default();

    const windowList = <box vertical /> as Widget.Box;

    const updateWindows = async() => {
        if (!App.get_window('win-screenshot')?.visible) {
            return;
        }

        const applications = AstalApps.Apps.new();

        windowList.children = (JSON.parse(await hyprMessage('j/clients')) as AstalHyprland.Client[])
            .filter((client) => client.workspace.id === hyprland.get_focused_workspace().get_id())
            .map((client) => (
                <button
                    className="item-btn"
                    cursor="pointer"

                    onButtonReleaseEvent={() => {
                        takeScreenshot(['-w', client.address]);
                    }}
                >
                    <box halign={Gtk.Align.CENTER}>
                        <icon icon={applications.fuzzy_query(client.class)[0].iconName} />

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

    hyprland.connect('notify::clients', updateWindows);
    hyprland.connect('notify::focused-workspace', updateWindows);

    const Shown = Variable<string>('monitors');

    const stack = (
        <stack
            shown={bind(Shown)}
            transitionType={Gtk.StackTransitionType.SLIDE_LEFT_RIGHT}
        >
            <scrollable name="monitors">
                <box vertical>
                    {bind(hyprland, 'monitors').as((monitors) => monitors.map((monitor) => (
                        <button
                            className="item-btn"
                            cursor="pointer"

                            onButtonReleaseEvent={() => {
                                takeScreenshot(['-o', monitor.name]);
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

    let frozen = false;
    const freezeIcon = <icon icon="checkbox-symbolic" /> as Widget.Icon;
    const freezeButton = (
        <button
            cursor="pointer"
            className="header-btn"

            onButtonReleaseEvent={() => {
                frozen = !frozen;
                freezeIcon.icon = frozen ?
                    'checkbox-checked-symbolic' :
                    'checkbox-symbolic';
            }}
        >
            <box halign={Gtk.Align.CENTER}>
                {freezeIcon}

                <Separator size={ICON_SEP} />

                freeze
            </box>
        </button>
    ) as Widget.Button;

    const regionButton = (
        <button
            cursor="pointer"
            className="header-btn"

            onButtonReleaseEvent={() => {
                takeScreenshot(['region', frozen ? 'true' : 'false'], 0);
            }}
        >
            <box halign={Gtk.Align.CENTER}>
                <icon icon="tool-crop-symbolic" />
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
                    <box>
                        {regionButton}
                        {freezeButton}
                    </box>
                </box>

                {stack}
            </box>
        </PopupWindow>
    );
};
